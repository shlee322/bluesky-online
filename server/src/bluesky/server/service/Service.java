package bluesky.server.service;

import bluesky.protocol.NetworkDecoder;
import bluesky.protocol.NetworkEncoder;
import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.PacketList;
import bluesky.protocol.packet.service.ServicePacketList;
import com.netflix.curator.framework.CuratorFramework;
import com.netflix.curator.framework.CuratorFrameworkFactory;
import com.netflix.curator.retry.ExponentialBackoffRetry;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.zookeeper.CreateMode;
import org.eclipse.paho.client.mqttv3.*;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.*;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

import java.net.InetSocketAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.Executors;

public class Service implements ServiceImpl{
    private static Logger logger = LogManager.getLogger("Service");
    private short serviceId;
    private String serviceAddress;
    private int servicePort;

    private Thread[] worker;
    private ConcurrentLinkedQueue<Runnable>[] workQueue;
    private Map<Short, ServiceImpl>[] serviceMap;

    private MemoryPersistence persistence = new MemoryPersistence();
    private MqttClient mqttClient;
    private MqttCallback mqttCallback = new MqttCallback() {
        @Override
        public void connectionLost(Throwable throwable) {
            getLogger().warn("Mqtt Connection Lost", throwable);
        }

        @Override
        public void messageArrived(String topic, MqttMessage mqttMessage) throws Exception {
            Service.this.arrivedMQTTMessage(topic, mqttMessage);
        }

        @Override
        public void deliveryComplete(IMqttDeliveryToken iMqttDeliveryToken) {
        }
    };
    private PacketList servicePacketList = new ServicePacketList();

    private CuratorFramework zooKeeperClient;

    protected Logger getLogger() {
        return Service.logger;
    }

    protected void setServiceInfo(short id, String address, int port) {
        this.serviceId = id;
        this.serviceAddress = address;
        this.servicePort = port;
    }

    public short getServiceId() {
        return this.serviceId;
    }

    public String getServiceType() {
        return "";
    }

    public String getServiceIdStr() {
        return String.valueOf(this.getServiceId());
    }

    public CuratorFramework getZooKeeperClient() {
        return this.zooKeeperClient;
    }

    protected void init() {
        initWorker(4);
        initNetwork();
        initMQTT();
        initZooKeeper();
        syncSerivce();
    }

    protected int getWorkerCount() {
        return this.worker.length;
    }

    private void initWorker(int num) {
        this.worker = new Thread[num];
        this.workQueue = new ConcurrentLinkedQueue[num];
        this.serviceMap = new HashMap[num];

        for(int i=0; i<num; i++) {
            this.workQueue[i] = new ConcurrentLinkedQueue<Runnable>();
            this.serviceMap[i] = new HashMap<Short, ServiceImpl>();

            final ConcurrentLinkedQueue<Runnable> localWorkQueue = this.workQueue[i];
            this.worker[i] = new Thread(new Runnable() {
                @Override
                public void run() {
                    while(true) {
                        if(localWorkQueue.isEmpty()) {
                            //인터럽트
                            continue;
                        }

                        Runnable runnable = localWorkQueue.poll();
                        if(runnable == null) continue;

                        try {
                            runnable.run();
                        }catch (Exception e) {
                            getLogger().warn("Worker Error", e);
                        }
                    }
                }
            });
            this.worker[i].start();
        }

        this.serviceMap[getWorkerIndex(this.getServiceId())].put(this.getServiceId(), this);
    }

    public void addWork(int key, Runnable runnable) {
        this.workQueue[this.getWorkerIndex(key)].add(runnable);
    }

    public int getWorkerIndex(int key) {
        return key%this.workQueue.length;
    }

    private void initNetwork() {
        getLogger().info("Init Service Network");
        ChannelFactory factory = new NioServerSocketChannelFactory(Executors.newCachedThreadPool(),
                Executors.newCachedThreadPool());

        ServerBootstrap b = new ServerBootstrap(factory);
        b.setPipelineFactory(new ChannelPipelineFactory() {
            @Override
            public ChannelPipeline getPipeline() throws Exception {
                ChannelPipeline pipeline = Channels.pipeline();
                pipeline.addLast("decoder", new NetworkDecoder(servicePacketList));
                pipeline.addLast("encoder", new NetworkEncoder(servicePacketList));
                pipeline.addLast("handler", new NetworkHandler(Service.this));
                return pipeline;
            }
        });
        b.setOption("child.tcpNoDelay", true);
        b.setOption("child.keepAlive", true);
        b.bind(new InetSocketAddress(this.servicePort));
    }

    private void initZooKeeper() {
        getLogger().info("Init ZooKeeper");
        this.zooKeeperClient = CuratorFrameworkFactory.builder().connectString("elab.kr:2181")
                .retryPolicy(new ExponentialBackoffRetry(1000, 3)).aclProvider(new ServiceACLProvider())
                .sessionTimeoutMs(10 * 1000)
                .build();
        this.zooKeeperClient.start();
        try {
            this.zooKeeperClient.getZookeeperClient().blockUntilConnectedOrTimedOut();
        } catch (InterruptedException e) {
            getLogger().fatal("Not Connected ZooKeeper", e);
        }

        this.registerService();
    }

    private void registerService() {
        getLogger().info("Register Service");
        String name = this.serviceAddress + ":" + this.servicePort;

        try {
            if(this.zooKeeperClient.checkExists().forPath("/service") == null) {
                this.zooKeeperClient.create().withMode(CreateMode.PERSISTENT).forPath("/service");
            }
            if(this.zooKeeperClient.checkExists().forPath("/maps") == null) {
                this.zooKeeperClient.create().withMode(CreateMode.PERSISTENT).forPath("/maps");
            }

            this.zooKeeperClient.create()
                    .withMode(CreateMode.EPHEMERAL)
                    .forPath("/service/" + this.getServiceIdStr(), name.getBytes());
        } catch (Exception e) {
            getLogger().warn("Failed Register Service", e);
        }
    }

    private void initMQTT() {
        getLogger().info("Init MQTT");
        try {
            MqttConnectOptions connOpts = new MqttConnectOptions();
            connOpts.setCleanSession(true);
            this.mqttClient = new MqttClient("tcp://elab.kr:1883", String.valueOf(this.getServiceId()), persistence);
            this.mqttClient.setCallback(this.mqttCallback);
            this.mqttClient.connect(connOpts);
        } catch (MqttException e) {
            getLogger().fatal("Not Connected MQTT broker", e);
        }
    }

    private void syncSerivce() {
        try {
            List<String> serviceList = this.zooKeeperClient.getChildren().forPath("/service");
            for(final String serviceId : serviceList) {
                if(serviceId.equals(this.getServiceIdStr())) continue;

                final short serviceIdNum = Short.valueOf(serviceId);
                addWork(serviceIdNum, new Runnable() {
                    @Override
                    public void run() {
                        try{
                            byte[] data = zooKeeperClient.getData().forPath("/service/"+serviceId).clone();
                            ServiceImpl s = serviceMap[getWorkerIndex(serviceIdNum)].get(serviceIdNum);
                            if(s == null) {
                                    serviceMap[getWorkerIndex(serviceIdNum)].put(serviceIdNum, new RemoteService(Service.this, serviceIdNum, new String(data)));
                            }
                        } catch (Exception e) {
                            getLogger().warn("Failed Service Data - " + serviceId, e);
                        }
                    }
                });
            }
        } catch (Exception e) {
            getLogger().warn("Failed Sync Service", e);
        }
    }

    public void subscribeMQTT(String topic) {
        try {
            this.mqttClient.subscribe(topic);
        } catch (MqttException e) {
            getLogger().warn("Subscribe MQTT Topic", e);
        }
    }

    public void publishMQTT(String topic, byte[] data) {
        MqttMessage message = new MqttMessage(data);
        message.setQos(2);
        try {
            this.mqttClient.publish(topic, message);
        } catch (MqttException e) {
            getLogger().warn("Publish MQTT Topic", e);
        }
    }

    protected void arrivedMQTTMessage(String topic, MqttMessage message) {
    }

    public void setRemoteService(final short serviceId, final ChannelHandlerContext ctx) {
        this.addWork(serviceId, new Runnable() {
            @Override
            public void run() {
                serviceMap[getWorkerIndex(serviceId)].put(serviceId, new RemoteService(Service.this, serviceId, ctx.getChannel()));
            }
        });
    }

    public void sendServiceMessage(ServiceImpl sender, final Packet packet) {
        this.receiveServiceMessage(sender, packet);
    }

    public void sendServiceMessage(final short serviceId, final Packet packet) {
        this.addWork(serviceId, new Runnable() {
            @Override
            public void run() {
                ServiceImpl service = serviceMap[getWorkerIndex(serviceId)].get(serviceId);
                service.sendServiceMessage(Service.this, packet);
            }
        });
    }

    public void receiveServiceMessage(ServiceImpl sender, Packet packet) {
    }
}
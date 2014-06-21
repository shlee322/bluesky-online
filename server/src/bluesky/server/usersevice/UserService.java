package bluesky.server.usersevice;

import bluesky.protocol.NetworkDecoder;
import bluesky.protocol.NetworkEncoder;
import bluesky.protocol.packet.client.ClientPacketList;
import bluesky.server.service.Service;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.*;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

import java.net.InetSocketAddress;
import java.util.HashMap;
import java.util.concurrent.Executors;

public class UserService extends Service {
    private ClientPacketList packetList = new ClientPacketList();
    private HashMap<Integer, MapProxy>[] maps;

    public UserService(short id, String address) {
        this.setServiceInfo(id, address, 8000 + id);
    }

    public void start() {
        this.init();
        this.maps = new HashMap[this.getWorkerCount()];
        for(int i=0; i<this.maps.length; i++) {
            this.maps[i] = new HashMap<Integer, MapProxy>();
        }
        this.subscribeMQTT("/event/link_map");

        ChannelFactory factory = new NioServerSocketChannelFactory(Executors.newCachedThreadPool(),
                Executors.newCachedThreadPool());

        ServerBootstrap b = new ServerBootstrap(factory);
        b.setPipelineFactory(new ChannelPipelineFactory() {
            @Override
            public ChannelPipeline getPipeline() throws Exception {
                ChannelPipeline pipeline = Channels.pipeline();
                pipeline.addLast("decoder", new NetworkDecoder(packetList));
                pipeline.addLast("encoder", new NetworkEncoder(packetList));
                pipeline.addLast("handler", new UserHandler(UserService.this));
                return pipeline;
            }
        });
        b.setOption("child.tcpNoDelay", true);
        b.setOption("child.keepAlive", true);
        b.bind(new InetSocketAddress(7000 + this.getServiceId()));
    }

    public void loginUser(final UserObject user) {
        final int mapid = user.getMapId();

        this.addWork(mapid, new Runnable() {
            @Override
            public void run() {
                HashMap<Integer, MapProxy> localMaps = maps[getWorkerIndex(mapid)];
                if(!localMaps.containsKey(mapid)) {
                    MapProxy newMap = new MapProxy(UserService.this, mapid);
                    localMaps.put(mapid, newMap);
                    newMap.linkMap();
                }

                MapProxy map = localMaps.get(mapid);
                user.moveMap(map, 10, 10);
            }
        });
    }

    protected void arrivedMQTTMessage(String topic, final MqttMessage message) {
        if(topic.equals("/event/link_map")) {
            byte[] mapIdBytes = message.getPayload();
            int map_id = 0;
            short service_id = 0;
            map_id |= mapIdBytes[0] << 24;
            map_id |= mapIdBytes[1] << 16;
            map_id |= mapIdBytes[2] << 8;
            map_id |= mapIdBytes[3];
            service_id |= mapIdBytes[4] << 8;
            service_id |= mapIdBytes[5];
            final int finalMap_id = map_id;
            final short finalService_id = service_id;
            this.addWork(map_id, new Runnable() {
                @Override
                public void run() {
                    HashMap<Integer, MapProxy> localMaps = maps[getWorkerIndex(finalMap_id)];
                    if(!localMaps.containsKey(finalMap_id)) {
                        return;
                    }
                    MapProxy map = localMaps.get(finalMap_id);
                    map.linkService(finalService_id);
                }
            });
            return;
        }
        if(topic.startsWith("/maps/")) {
            String subTopic = topic.substring(6);
            int mapIdEndIndex = subTopic.indexOf("/");
            final int mapId = Integer.valueOf(subTopic.substring(0, mapIdEndIndex));
            subTopic = subTopic.substring(mapIdEndIndex);
            final String finalSubTopic = subTopic;
            this.addWork(mapId, new Runnable() {
                @Override
                public void run() {
                    HashMap<Integer, MapProxy> localMaps = maps[getWorkerIndex(mapId)];
                    if(!localMaps.containsKey(mapId)) {
                        return;
                    }
                    MapProxy map = localMaps.get(mapId);
                    map.arrivedMQTTMessage(finalSubTopic, message.getPayload());
                }
            });
        }

    }

    public void getMapInfo(final UserObject user, final int mapId) {
        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                HashMap<Integer, MapProxy> localMaps = maps[getWorkerIndex(mapId)];
                if(!localMaps.containsKey(mapId)) {
                    getLogger().warn("GetMapInfo - 맵 정보를 찾을 수 없습니다.");
                    return;
                }

                MapProxy map = localMaps.get(mapId);
                map.sendMapInfo(user);
            }
        });
    }
}

package bluesky.server.service;

import bluesky.protocol.NetworkDecoder;
import bluesky.protocol.NetworkEncoder;
import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.PacketList;
import bluesky.protocol.packet.service.ServicePacketList;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jboss.netty.bootstrap.ClientBootstrap;
import org.jboss.netty.channel.*;
import org.jboss.netty.channel.socket.nio.NioClientSocketChannelFactory;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

public class RemoteService implements ServiceImpl {
    private static Logger logger = LogManager.getLogger("RemoteService");
    private static PacketList servicePacketList = new ServicePacketList();

    private Service service;

    private short id;
    private Channel channel;

    public RemoteService(Service service, short id, String host) {
        this.service = service;
        this.id = id;
        String[] h = host.split(":");

        ChannelFactory factory = new NioClientSocketChannelFactory(Executors.newCachedThreadPool(),
                Executors.newCachedThreadPool());
        ClientBootstrap b = new ClientBootstrap(factory);
        b.setPipelineFactory(new ChannelPipelineFactory() {
            @Override
            public ChannelPipeline getPipeline() throws Exception {
                ChannelPipeline pipeline = Channels.pipeline();
                pipeline.addLast("decoder", new NetworkDecoder(servicePacketList));
                pipeline.addLast("encoder", new NetworkEncoder(servicePacketList));
                pipeline.addLast("handler", new NetworkHandler(RemoteService.this));
                return pipeline;
            }
        });

        try {
            b.connect(new InetSocketAddress(h[0], Integer.valueOf(h[1]))).sync();
            logger.info("Connect " + service.getServiceIdStr() + " -> " + id + "(" + host + ")");
        } catch (Exception e) {
            logger.warn("Connect Error " + service.getServiceIdStr() + " -> " + id + "(" + host + ")", e);
        }
    }

    public RemoteService(Service service, short serviceId, Channel ctx) {
        this.service = service;
        this.id = serviceId;
        this.setChannel(ctx);
    }

    public Service getService() {
        return this.service;
    }

    @Override
    public short getServiceId() {
        return this.id;
    }

    @Override
    public String getServiceType() {
        return "";
    }

    public void setChannel(Channel ctx) {
        this.channel = ctx;
    }

    public void sendServiceMessage(ServiceImpl sender, final Packet packet) {
        this.channel.write(packet);
    }

    @Override
    public void receiveServiceMessage(ServiceImpl sender, Packet packet) {
        logger.warn("RemoteService는 receiveServiceMessage를 사용할 수 없습니다.");
    }
}
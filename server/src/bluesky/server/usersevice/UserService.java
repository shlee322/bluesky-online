package bluesky.server.usersevice;

import bluesky.protocol.NetworkDecoder;
import bluesky.protocol.NetworkEncoder;
import bluesky.protocol.packet.client.ClientPacketList;
import bluesky.server.service.NetworkHandler;
import bluesky.server.service.Service;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.ChannelFactory;
import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.ChannelPipelineFactory;
import org.jboss.netty.channel.Channels;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

public class UserService extends Service {
    private ClientPacketList packetList = new ClientPacketList();

    public UserService(short id, String address) {
        this.setServiceInfo(id, address, 8000 + id);
    }

    public void start() {
        this.init();

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
}

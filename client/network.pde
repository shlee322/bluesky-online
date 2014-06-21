import java.lang.Thread;
import java.lang.Runnable;
import java.util.concurrent.Executors;
import java.net.InetSocketAddress;
import org.jboss.netty.bootstrap.ClientBootstrap;
import org.jboss.netty.channel.socket.nio.NioClientSocketChannelFactory;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBufferOutputStream;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;
import org.jboss.netty.handler.codec.oneone.OneToOneEncoder;
import org.jboss.netty.handler.codec.frame.FrameDecoder;
import org.msgpack.MessagePack;
import org.msgpack.packer.Packer;
import org.msgpack.annotation.Message;

public static class Network implements Model {
	private ClientPacketList packetList = new ClientPacketList();
	public void init(Scene scene) {
	}

    public void release(Scene scene) {
    }

    public void initNetwork() {
    	new Thread(new Runnable() {
    		public void run() {
    			initNetwork2();
    		}
    	}).start();
    }

    private void initNetwork2() {
    	ChannelFactory factory = new NioClientSocketChannelFactory(Executors.newCachedThreadPool(),
                Executors.newCachedThreadPool());

    	ClientBootstrap b = new ClientBootstrap(factory);
        b.setPipelineFactory(new ChannelPipelineFactory() {
            @Override
            public ChannelPipeline getPipeline() throws Exception {
                ChannelPipeline pipeline = Channels.pipeline();
                pipeline.addLast("decoder", new NetworkDecoder(packetList));
                pipeline.addLast("encoder", new NetworkEncoder(packetList));
                pipeline.addLast("handler", new UserHandler());
                return pipeline;
            }
        });

        try {
            b.connect(new InetSocketAddress("183.96.22.222", 7001)).sync();
            Engine.getInstance().setScene(new LoginScene());
        } catch (Exception e) {
            Engine.getInstance().showNotify("서버 접속 실패", -1);
        }
    }
}

public static class UserHandler extends SimpleChannelUpstreamHandler {
    public UserHandler() {
    }

    public void channelConnected(org.jboss.netty.channel.ChannelHandlerContext ctx, org.jboss.netty.channel.ChannelStateEvent e) {
    	Engine.getInstance().showNotify("서버 접속 성공", 120);
    }

    public void channelDisconnected(org.jboss.netty.channel.ChannelHandlerContext ctx, org.jboss.netty.channel.ChannelStateEvent e) {
        Engine.getInstance().showNotify("서버와의 연결이 끊어졌습니다.", -1);
    }

    public void messageReceived(org.jboss.netty.channel.ChannelHandlerContext ctx, org.jboss.netty.channel.MessageEvent e) { 
        if(e.getMessage() instanceof SC_Notify) {
            SC_Notify notify = (SC_Notify)e.getMessage();
            Engine.getInstance().showNotify(notify.msg, notify.time);
        }
    }

    public void exceptionCaught(org.jboss.netty.channel.ChannelHandlerContext ctx, org.jboss.netty.channel.ExceptionEvent e) {
        e.getCause().printStackTrace();
    }
}


public static class ClientPacketList extends PacketList {
    private static final Class<?>[] PacketList = new Class<?>[] {
            null,
            SC_Notify.class
    };

    @Override
    public Class<?>[] getPacketList() {
        return PacketList;
    }
}

@Message
public static class SC_Notify implements Packet {
    public String msg;
    public int time;

    @Override
    public byte getPacketId() { return 1; }

    public SC_Notify() {}
    public SC_Notify(String msg, int time) {
        this.msg = msg;
        this.time = time;
    }
}


public interface Packet {
    public byte getPacketId();
}

public static abstract class PacketList {
    public abstract Class<?>[] getPacketList();
}

public static class NetworkEncoder extends OneToOneEncoder {
    private PacketList packetList;
    private MessagePack msgpack = new MessagePack();
    private static final byte[] LENGTH_PLACEHOLDER = new byte[4];

    public NetworkEncoder(PacketList packetList) {
        this.packetList = packetList;
    }

    @Override
    protected Object encode(ChannelHandlerContext ctx, Channel channel, Object packet) throws Exception {
        ChannelBufferOutputStream out =
                new ChannelBufferOutputStream(ChannelBuffers.dynamicBuffer(
                        512, ctx.getChannel().getConfig().getBufferFactory()));
        out.writeByte(1);
        out.writeByte(((Packet) packet).getPacketId());
        out.write(LENGTH_PLACEHOLDER);
        Packer packer = this.msgpack.createPacker(out);
        packer.write(packet);
        packer.close();

        ChannelBuffer encoded = out.buffer();
        encoded.setInt(2, encoded.writerIndex() - 6);
        return encoded;
    }
}

public static class NetworkDecoder extends FrameDecoder {
    private PacketList packetList;
    private MessagePack msgpack = new MessagePack();

    public NetworkDecoder(PacketList packetList) {
        this.packetList = packetList;
    }

    @Override
    protected Object decode(ChannelHandlerContext ctx, Channel channel, ChannelBuffer buf) throws Exception {
        if (buf.readableBytes() < 6) return null;

        buf.markReaderIndex();
        buf.readByte();
        int type = buf.readByte();
        int len = buf.readInt();

        if (buf.readableBytes() < len) {
            buf.resetReaderIndex();
            return null;
        }

        if (type < 0 || type >= packetList.getPacketList().length || packetList.getPacketList()[type] == null) {
            return null;
        }

        byte[] data = new byte[len];
        buf.readBytes(data);

        return this.msgpack.read(data, packetList.getPacketList()[type]);
    }
}
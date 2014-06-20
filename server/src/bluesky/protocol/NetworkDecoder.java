package bluesky.protocol;

import bluesky.protocol.packet.PacketList;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.handler.codec.frame.FrameDecoder;
import org.msgpack.MessagePack;

public class NetworkDecoder extends FrameDecoder {
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
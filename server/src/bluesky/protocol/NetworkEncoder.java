package bluesky.protocol;

import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.PacketList;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBufferOutputStream;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.Channel;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.handler.codec.oneone.OneToOneEncoder;
import org.msgpack.MessagePack;
import org.msgpack.packer.Packer;

public class NetworkEncoder extends OneToOneEncoder {
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
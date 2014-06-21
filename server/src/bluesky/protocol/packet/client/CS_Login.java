package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class CS_Login implements Packet {
    public String id;
    public String pw;

    @Override
    public byte getPacketId() { return 3; }
}

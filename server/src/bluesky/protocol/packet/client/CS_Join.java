package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class CS_Join implements Packet {
    public String id;
    public String pw;
    public String name;

    @Override
    public byte getPacketId() { return 2; }
}

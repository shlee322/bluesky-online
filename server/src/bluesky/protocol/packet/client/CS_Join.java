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

    public CS_Join() {

    }

    public CS_Join(String id, String pw, String name) {
        this.id = id;
        this.pw = pw;
        this.name = name;
    }
}

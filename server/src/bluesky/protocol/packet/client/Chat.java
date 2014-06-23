package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class Chat implements Packet {
    public int map_id;
    public long object_id;
    public String msg;

    public Chat() {
    }

    public Chat(int map_id, long object_id, String msg) {
        this.map_id = map_id;
        this.object_id = object_id;
        this.msg = msg;
    }

    @Override
    public byte getPacketId() { return 10; }
}

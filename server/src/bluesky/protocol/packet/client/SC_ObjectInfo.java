package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class SC_ObjectInfo implements Packet {
    public int map_id;
    public long object_id;
    public String name;

    @Override
    public byte getPacketId() { return 8; }

    public SC_ObjectInfo() {}
    public SC_ObjectInfo(int map_id, long object_id, String name) {
        this.map_id = map_id;
        this.object_id = object_id;
        this.name = name;
    }
}

package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class CS_PickUpItem implements Packet {
    public long object_id;
    public int map_id;

    @Override
    public byte getPacketId() { return 14; }

    public CS_PickUpItem() {}
    public CS_PickUpItem(long object_id, int map_id) {
        this.object_id = object_id;
        this.map_id = map_id;
    }
}

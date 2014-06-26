package bluesky.protocol.packet.service;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class ServicePickUpItem implements Packet {
    public long object_id;
    public int map_id;

    @Override
    public byte getPacketId() { return 6; }

    public ServicePickUpItem() {}
    public ServicePickUpItem(long object_id, int map_id) {
        this.object_id = object_id;
        this.map_id = map_id;
    }
}

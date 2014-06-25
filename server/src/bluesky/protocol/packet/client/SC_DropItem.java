package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class SC_DropItem implements Packet {
    public long uuid;
    public int mapId;
    public int x;
    public int y;
    public byte resId;

    @Override
    public byte getPacketId() { return 12; }

    public SC_DropItem(){}
    public SC_DropItem(long uuid, int mapId, int x, int y, byte resId) {
        this.uuid = uuid;
        this.mapId = mapId;
        this.x = x;
        this.y = y;
        this.resId = resId;
    }
}

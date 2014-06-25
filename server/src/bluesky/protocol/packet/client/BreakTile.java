package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class BreakTile implements Packet {
    public int map_id;
    public int x;
    public int y;

    @Override
    public byte getPacketId() { return 11; }

    public BreakTile() {}
    public BreakTile(int mapId, int x, int y) {
        this.map_id = mapId;
        this.x = x;
        this.y = y;
    }
}

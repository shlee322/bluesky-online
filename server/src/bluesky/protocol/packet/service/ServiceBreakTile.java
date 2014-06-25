package bluesky.protocol.packet.service;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class ServiceBreakTile  implements Packet {
    public int map_id;
    public int x;
    public int y;

    @Override
    public byte getPacketId() {
        return 4;
    }

    public ServiceBreakTile() {}
    public ServiceBreakTile(int mapId, int x, int y) {
        this.map_id = mapId;
        this.x = x;
        this.y = y;
    }

}

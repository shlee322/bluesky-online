package bluesky.protocol.packet.service;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class ServiceSetTile implements Packet {
    public int map_id;
    public int x;
    public int y;
    public byte res_id;

    @Override
    public byte getPacketId() {
        return 5;
    }

    public ServiceSetTile() {}
    public ServiceSetTile(int mapId, int x, int y, byte res_id) {
        this.map_id = mapId;
        this.x = x;
        this.y = y;
        this.res_id = res_id;
    }

}

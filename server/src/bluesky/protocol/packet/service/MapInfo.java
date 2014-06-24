package bluesky.protocol.packet.service;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class MapInfo implements Packet {
    public long request_id;
    public int request_map_id;
    public int map_id;
    public int[] around_map_id;
    public byte[] tiles;

    @Override
    public byte getPacketId() {
        return 3;
    }

    public MapInfo() {

    }

    public MapInfo(long request_id, int request_map_id, int map_id, int[] around_map_id, byte[] tiles) {
        this.request_id = request_id;
        this.request_map_id = request_map_id;
        this.map_id = map_id;
        this.around_map_id = around_map_id;
        this.tiles = tiles;
    }
}

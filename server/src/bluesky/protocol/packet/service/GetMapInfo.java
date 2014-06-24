package bluesky.protocol.packet.service;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class GetMapInfo implements Packet {
    public long request_id;
    public int request_map_id;
    public int map_id;

    @Override
    public byte getPacketId() {
        return 2;
    }

    public GetMapInfo() {

    }

    public GetMapInfo(long request_id, int request_map_id, int map_id) {
        this.request_id = request_id;
        this.request_map_id = request_map_id;
        this.map_id = map_id;
    }
}

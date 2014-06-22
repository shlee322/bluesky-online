package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class MoveObject implements Packet {
    public long object_id;
    public int src_map;
    public int src_x;
    public int src_y;
    public int dest_map;
    public int dest_x;
    public int dest_y;

    @Override
    public byte getPacketId() { return 9; }
    public MoveObject() {}
    public MoveObject(long object_id, int src_map, int src_x, int src_y, int dest_map, int dest_x, int dest_y) {
        this.object_id = object_id;
        this.src_map = src_map;
        this.src_x = src_x;
        this.src_y = src_y;
        this.dest_map = dest_map;
        this.dest_x = dest_x;
        this.dest_y = dest_y;
    }
}

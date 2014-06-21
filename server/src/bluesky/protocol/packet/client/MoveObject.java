package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class MoveObject implements Packet {
    public int object_id;
    public int src_map;
    public int src_x;
    public int src_y;
    public int dest_map;
    public int dest_x;
    public int dest_y;

    @Override
    public byte getPacketId() { return 9; }
}

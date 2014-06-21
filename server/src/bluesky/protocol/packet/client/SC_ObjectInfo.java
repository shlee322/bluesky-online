package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class SC_ObjectInfo implements Packet {
    public int map_id;
    public int object_id;

    @Override
    public byte getPacketId() { return 8; }
}

package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class SC_MapInfo implements Packet {
    public int map_id;
    public int[] around_map_id;
    public byte[] tiles;

    @Override
    public byte getPacketId() { return 6; }
}

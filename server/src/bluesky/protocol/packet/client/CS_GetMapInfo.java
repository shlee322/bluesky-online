package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class CS_GetMapInfo implements Packet {
    public int map_id;

    @Override
    public byte getPacketId() { return 5; }
}

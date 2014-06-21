package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;

public class SC_MapInfo implements Packet {
    public int map_id;

    @Override
    public byte getPacketId() { return 6; }
}

package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class SetTile implements Packet {
    public int map_id;
    public int x;
    public int y;
    public byte res_id;

    @Override
    public byte getPacketId() { return 13; }

    public SetTile() {}
    public SetTile(int map_id, int x, int y, byte res_id) {
        this.map_id = map_id;
        this.x = x;
        this.y = y;
        this.res_id = res_id;
    }
}

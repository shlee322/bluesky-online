package bluesky.protocol.packet.client;

import bluesky.protocol.packet.Packet;
import org.msgpack.annotation.Message;

@Message
public class SC_Notify implements Packet {
    public String msg;
    public int time;

    @Override
    public byte getPacketId() { return 1; }

    public SC_Notify() {}
    public SC_Notify(String msg, int time) {
        this.msg = msg;
        this.time = time;
    }
}

package bluesky.protocol.packet.client;

public class ClientPacketList extends bluesky.protocol.packet.PacketList {
    private static final Class<?>[] PacketList = new Class<?>[] {
            null,
            SC_Notify.class
    };

    @Override
    public Class<?>[] getPacketList() {
        return PacketList;
    }
}

package bluesky.protocol.packet.client;

public class ClientPacketList extends bluesky.protocol.packet.PacketList {
    private static final Class<?>[] PacketList = new Class<?>[] {
            null
    };

    @Override
    public Class<?>[] getPacketList() {
        return PacketList;
    }
}

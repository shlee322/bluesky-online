package bluesky.protocol.packet.service;

public class ServicePacketList extends bluesky.protocol.packet.PacketList {
    private static final Class<?>[] PacketList = new Class<?>[] {
            null,
            ServiceInfo.class
    };

    @Override
    public Class<?>[] getPacketList() {
        return PacketList;
    }
}

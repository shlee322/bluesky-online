package bluesky.protocol.packet.client;

public class ClientPacketList extends bluesky.protocol.packet.PacketList {
    private static final Class<?>[] PacketList = new Class<?>[] {
            null,
            SC_Notify.class,
            CS_Join.class,
            CS_Login.class,
            SC_MoveMap.class,
            CS_GetMapInfo.class,
            SC_MapInfo.class,
            CS_GetObjectInfo.class,
            SC_ObjectInfo.class,
            MoveObject.class,
            Chat.class,
            BreakTile.class,
            SC_DropItem.class,
            SetTile.class,
            CS_PickUpItem.class,
            SC_RemoveDropItem.class
    };

    @Override
    public Class<?>[] getPacketList() {
        return PacketList;
    }
}

package bluesky.server.mapservice;

import bluesky.protocol.packet.service.GetMapInfo;
import bluesky.protocol.packet.service.MapInfo;
import bluesky.server.db.DBManager;
import bluesky.server.service.ServiceImpl;
import bluesky.server.usersevice.UserObject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Map {
    private int mapId;
    private int mapX;
    private int mapY;
    private byte[] tiles;

    public Map(MapService service, int mapId) {
        this.mapId = mapId;

        try {
            Connection conn = DBManager.getInstance().getConnection();
            PreparedStatement statement =
                    conn.prepareStatement("SELECT * FROM `maps` WHERE `id`=?;");

            statement.setInt(1, mapId);

            ResultSet result = statement.executeQuery();
            if(result.next()) {
                this.mapX = result.getInt("x");
                this.mapY = result.getInt("y");
                this.tiles = result.getBytes("tiles");
            } else {
                //맵 발견 못함
            }

            result.close();
            statement.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Map(int mapId, int x, int y) {
    }

    public int getMapId() {
        return this.mapId;
    }

    public void arrivedMQTTMessage(String subTopic, byte[] data) {
        //자기맵에 온 데이터면 주위맵으로 보낸다.
    }

    public void getMapInfo(ServiceImpl sender, GetMapInfo getMapInfo) {
        sender.sendServiceMessage(null, new MapInfo(getMapInfo.request_id, this.getMapId(), this.tiles));
    }
}

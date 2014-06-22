package bluesky.server.mapservice;

import bluesky.server.db.DBManager;

import java.sql.Connection;
import java.sql.SQLException;

public class Map {
    private int mapId;

    public Map(int mapId) {
        this.mapId = mapId;

        try {
            Connection connection = DBManager.getInstance().getConnection();
            connection.close();
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
}

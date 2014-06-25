package bluesky.server.mapservice.generator;

import bluesky.server.db.DBManager;
import bluesky.server.mapservice.IMap;
import bluesky.server.mapservice.Map;
import bluesky.server.mapservice.MapService;

import java.sql.*;

public class RefMap implements IMap {
    private MapService service;
    private int mapId = -1;
    private int mapX;
    private int mapY;
    private byte[] tiles;

    public RefMap(MapService service, int x, int y, IMapTilesGenerator generator) {
        this.service = service;
        this.mapX = x;
        this.mapY = y;
        this.tiles = new byte[400];

        generator.generate(this);
    }

    @Override
    public int getMapId() {
        return 0;
    }

    @Override
    public int getMapX() {
        return this.mapX;
    }

    @Override
    public int getMapY() {
        return this.mapY;
    }

    @Override
    public void setTile(int x, int y, byte code) {
        this.tiles[y*20 + x] = code;
    }

    public void save() {
        //DB 생성
        //MQTT로 알림
        try {
            Connection conn = DBManager.getInstance().getConnection();
            PreparedStatement statement =
                    conn.prepareStatement("INSERT INTO `maps` (`x`, `y`, `tiles`) VALUES(?, ?, ?);",
                            Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, this.getMapX());
            statement.setInt(2, this.getMapY());
            statement.setBytes(3, this.tiles);
            statement.executeUpdate();
            ResultSet result = statement.getGeneratedKeys();
            if(result.next()) {
                this.mapId = result.getInt(1);
            }
            statement.close();
            conn.close();
        } catch (SQLException e) {
        }

        if(this.mapId == -1) return;
        this.publishCreateMapEvent();
    }

    private void publishCreateMapEvent() {
        byte[] mapIdData = new byte[] {
            (byte)((mapId & 0xFF000000) >> 24),
            (byte)((mapId & 0xFF0000) >> 16),
            (byte)((mapId & 0xFF00) >> 8),
            (byte)(mapId & 0xFF),
            0
        };

        Connection conn = null;
        try {
            conn = DBManager.getInstance().getConnection();
            for (int i = 0; i < 8; i++) {
                PreparedStatement statement =
                        conn.prepareStatement("SELECT `id` FROM `maps` WHERE `x`=? and `y`=?;");
                statement.setInt(1, this.getMapX() + Map.getRelativeX(i));
                statement.setInt(2, this.getMapY() + Map.getRelativeY(i));

                ResultSet result = statement.executeQuery();
                if(result.next()) {
                    int position = i<4 ? i+4 : i-4;
                    mapIdData[4] = (byte)(position & 0xFF);
                    this.service.publishMQTT("/event/create_map/" + result.getInt("id"), mapIdData);
                }
                result.close();
                statement.close();
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

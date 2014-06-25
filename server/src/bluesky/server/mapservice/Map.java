package bluesky.server.mapservice;

import bluesky.protocol.packet.service.GetMapInfo;
import bluesky.protocol.packet.service.MapInfo;
import bluesky.server.db.DBManager;
import bluesky.server.mapservice.generator.RefMap;
import bluesky.server.service.ServiceImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Map implements IMap {
    private MapService service;
    private int mapId;
    private int mapX;
    private int mapY;
    private byte[] tiles;
    private int[] aroundMapId = new int[8];

    public Map(MapService service, int mapId) {
        this.service = service;
        this.mapId = mapId;
        for(int i=0; i<aroundMapId.length; i++) {
            this.aroundMapId[i] = -1;
        }

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

                loadAroundMapId();
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

    private void loadAroundMapId() {
        Connection conn = null;
        try {
            conn = DBManager.getInstance().getConnection();
            for (int i = 0; i < this.aroundMapId.length; i++) {
                PreparedStatement statement =
                        conn.prepareStatement("SELECT `id` FROM `maps` WHERE `x`=? and `y`=?;");
                statement.setInt(1, this.getMapX() + this.getRelativeX(i));
                statement.setInt(2, this.getMapY() + this.getRelativeY(i));

                ResultSet result = statement.executeQuery();
                if(result.next()) {
                    this.aroundMapId[i] = result.getInt("id");
                }
                result.close();
                statement.close();
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int getMapId() {
        return this.mapId;
    }

    public void arrivedMQTTMessage(String subTopic, byte[] data) {
        if(subTopic.equals("/join")) {
            for(int i=0; i<8; i++) {
                if(this.aroundMapId[i] != -1) continue;
                //생성을 하고 생성했음을 MQTT로 근처맵 관리하는 애들한테 링크됬음을 알림.
                this.createMap(this.getMapX() + this.getRelativeX(i), this.getMapY() + this.getRelativeY(i));
            }
        }

        //자기맵에 온 데이터면 주위맵으로 보낸다.
    }

    private void createMap(final int x, final int y) {
        this.service.addWork(0, new Runnable() {
            @Override
            public void run() {
                new RefMap(service, x, y, service.getMapGenerator()).save();
            }
        });
    }

    public void getMapInfo(ServiceImpl sender, GetMapInfo getMapInfo) {
        sender.sendServiceMessage(null, new MapInfo(getMapInfo.request_id, getMapInfo.request_map_id,
                this.getMapId(), this.aroundMapId, this.tiles));
    }

    public static int getRelativeX(int position) {
        if(position>7 || position<0) {
            return 0;
            //throw new Exception("상대 범위 초과");
        }
        if(position>4) return -1;
        if(position==4) return 0;
        if(position>0) return 1;
        return 0;
    }

    public static int getRelativeY(int position) {
        if(position>7 || position<0) {
            return 0;
            //throw new Exception("상대 범위 초과");
        }
        if(position<2) return 1;
        if(position==2) return 0;
        if(position<6) return -1;
        if(position==6) return 0;
        return 1;
    }

    public int getMapX() {
        return mapX;
    }

    public int getMapY() {
        return mapY;
    }

    public void setTile(int x, int y, byte code){
        this.tiles[y*20 + x] = code;
    }

    @Override
    public void save() {
    }


    public void linkAroundMap(int mapId, int position) {
        if(this.aroundMapId[position] != -1) {
            return;
        }

        this.aroundMapId[position] = mapId;

        this.service.publishMQTT("/maps/" + this.getMapId() + "/link_around_map", new byte[]{
                (byte)(position & 0xFF),
                (byte)((mapId & 0xFF000000) >> 24),
                (byte)((mapId & 0xFF0000) >> 16),
                (byte)((mapId & 0xFF00) >> 8),
                (byte)(mapId & 0xFF)
        });
    }
}

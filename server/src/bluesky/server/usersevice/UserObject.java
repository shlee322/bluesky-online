package bluesky.server.usersevice;

import bluesky.protocol.packet.client.SC_MoveMap;
import org.jboss.netty.channel.Channel;

public class UserObject {
    private static int testIndex = 0;
    private UserService service;
    private Channel channel;

    private String name;

    private long uuid = testIndex++;
    private int loginMapId;
    private MapProxy map;
    private int x;
    private int y;

    private Inventory inventory;

    public UserObject(UserService service, Channel channel, String name, int map_id, int x, int y) {
        this.service = service;
        this.channel = channel;
        this.name = name;
        this.loginMapId = map_id;
        this.x = x;
        this.y = y;
        this.inventory = new Inventory();
    }

    public void moveMap(MapProxy map, int x, int y) {
        this.map = map;
        this.x = x;
        this.y = y;

        map.joinUser(this);

        this.channel.write(new SC_MoveMap(this.getUUID(), this.map.getMapId()));
    }

    public Channel getChannel() {
        return this.channel;
    }

    public long getUUID() {
        return uuid;
    }

    public int getMapId() {
        return map != null ? map.getMapId() : this.loginMapId;
    }

    public int getX() {
        return this.x;
    }

    public int getY() {
        return this.y;
    }

    public String getName() {
        return this.name;
    }

    public void setMap(MapProxy map) {
        this.map = map;
    }

    public void setX(int x) {
        this.x = x;
    }

    public void setY(int y) {
        this.y = y;
    }
}

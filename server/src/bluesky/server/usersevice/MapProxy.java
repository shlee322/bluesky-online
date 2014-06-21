package bluesky.server.usersevice;

import bluesky.protocol.packet.service.GetMapInfo;

public class MapProxy {
    private UserService service;
    private int map_id;
    private short serviceId;

    public MapProxy(UserService service, int map_id) {
        this.service = service;
        this.map_id = map_id;
    }

    public void linkMap() {
        this.service.subscribeMQTT("/maps/" + map_id + "/#");

        try {
            byte[] serviceIdBytes = service.getZooKeeperClient().getData().forPath("/maps/" + map_id).clone();
            short serviceId=0;
            serviceId |= (((int)serviceIdBytes[0])<<8)&0xFF00;
            serviceId |= (((int)serviceIdBytes[1]))&0xFF;
            this.serviceId = serviceId;
        } catch (Exception e) {
            //맵 서버 발견 못함
            this.service.publishMQTT("/event/request_map", new byte[]{
                    (byte)(this.map_id & 0xFF000000 >> 24),
                    (byte)(this.map_id & 0xFF0000 >> 16),
                    (byte)(this.map_id & 0xFF00 >> 8),
                    (byte)(this.map_id & 0xFF)
            });
        }
    }

    public void joinUser(UserObject user) {
        //UUID
        //x
        //y
        this.service.publishMQTT("/maps/" + getMapId() + "/join", new byte[]{
        });
    }

    public void linkService(short serviceId) {
        if(this.serviceId == serviceId) return;
        this.serviceId = serviceId;
    }

    public int getMapId() {
        return this.map_id;
    }

    public void sendMapInfo(UserObject user) {
        this.service.sendServiceMessage(this.serviceId, new GetMapInfo(user.getUUID(), getMapId()));
    }

    public void arrivedMQTTMessage(String subTopic, byte[] data) {
    }
}

package bluesky.server.usersevice;

import bluesky.protocol.packet.client.MoveObject;
import bluesky.protocol.packet.client.SC_MapInfo;
import bluesky.protocol.packet.service.GetMapInfo;
import bluesky.protocol.packet.service.MapInfo;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.LinkedList;

public class MapProxy {
    private final static Logger logger = LogManager.getLogger("MapProxy");

    private UserService service;
    private int map_id;
    private short serviceId;

    private LinkedList<UserObject> waitSendMapInfoUser = new LinkedList<UserObject>();
    private LinkedList<UserObject> objects = new LinkedList<UserObject>();

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
            //맵 서버를 발견하지 못할 경우 맵 서버 할당 요청
            this.service.publishMQTT("/event/request_map", new byte[]{
                    (byte)((this.map_id & 0xFF000000) >> 24),
                    (byte)((this.map_id & 0xFF0000) >> 16),
                    (byte)((this.map_id & 0xFF00) >> 8),
                    (byte)((this.map_id & 0xFF))
            });
        }
    }

    public void joinUser(UserObject user) {
        this.objects.add(user);
        //serviceId
        //UUID
        //x
        //y
        this.service.publishMQTT("/maps/" + getMapId() + "/join", new byte[]{
        });
    }

    public void exitUser(UserObject user) {
        this.objects.remove(user);

        //TODO : 안쓰는 맵프록시 제거 개발
    }

    public void linkService(short serviceId) {
        if(this.serviceId == serviceId) return;
        this.serviceId = serviceId;

        for(UserObject user : this.waitSendMapInfoUser) {
            this.sendMapInfo(user);
        }
        this.waitSendMapInfoUser.clear();
    }

    public int getMapId() {
        return this.map_id;
    }

    public void sendMapInfo(UserObject user) {
        if(this.serviceId == 0) {
            //아직 연결 못함
            waitSendMapInfoUser.add(user);
            return;
        }
        this.service.sendServiceMessage(this.serviceId, new GetMapInfo(user.getUUID(), getMapId()));
    }

    public void arrivedMQTTMessage(String subTopic, byte[] data) {
    }

    public void moveObject(UserObject user, MoveObject packet) {
        if(packet.src_map == getMapId()) { //패킷 전송 뿅뿅
            System.out.println("패킷 전송 뿅뿅!");
            //자기가 관리하는 오브젝트 들한테 보내고
            //MQTT로
        }

        if(packet.src_map == packet.dest_map) return;
        if(packet.dest_map == getMapId()) {
            this.objects.add(user);
        } else {
            this.objects.remove(user);
        }
    }

    public void responseMapInfo(MapInfo info) {
        for(UserObject user : this.objects) {
            if(user.getUUID() != info.request_id) continue;

            SC_MapInfo mapInfo = new SC_MapInfo();
            mapInfo.map_id = this.getMapId();
            mapInfo.around_map_id = new int[]{-1,-1,-1,-1,-1,-1,-1,-1};
            mapInfo.tiles = info.tiles;
            user.getChannel().write(mapInfo);
            return;
        }
    }
}

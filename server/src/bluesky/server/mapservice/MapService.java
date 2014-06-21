package bluesky.server.mapservice;

import bluesky.protocol.packet.Packet;
import bluesky.server.service.Service;
import bluesky.server.service.ServiceImpl;
import org.apache.zookeeper.CreateMode;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.util.HashMap;

public class MapService extends Service {
    private HashMap<Integer, Map>[] maps;

    public MapService(short id, String address) {
        this.setServiceInfo(id, address, 8000 + id);
    }

    public void start() {
        this.init();
        this.maps = new HashMap[this.getWorkerCount()];
        for(int i=0; i<this.getWorkerCount(); i++) {
            this.maps[i] = new HashMap<Integer, Map>();
        }
        this.subscribeMQTT("/event/request_map");
    }

    protected void arrivedMQTTMessage(String topic, MqttMessage message) {
        if(topic.equals("/event/request_map")) {
            byte[] mapIdBytes = message.getPayload();
            int map_id = 0;
            map_id |= mapIdBytes[0] << 24;
            map_id |= mapIdBytes[1] << 16;
            map_id |= mapIdBytes[2] << 8;
            map_id |= mapIdBytes[3];
            final int finalMap_id = map_id;
            this.addWork(map_id, new Runnable() {
                @Override
                public void run() {
                    linkMap(finalMap_id);
                }
            });
        }
    }

    private void linkMap(int map_id) {
        try {
            this.getZooKeeperClient().create()
                    .withMode(CreateMode.EPHEMERAL)
                    .forPath("/maps/" + map_id, new byte[]{
                            (byte) (this.getServiceId() & 0xFF00 >> 8),
                            (byte) (this.getServiceId() & 0xFF)
                    });
            this.maps[getWorkerIndex(map_id)].put(map_id, new Map());
            this.publishMQTT("/event/link_map", new byte[]{
                    (byte)(map_id & 0xFF000000 >> 24),
                    (byte)(map_id & 0xFF0000 >> 16),
                    (byte)(map_id & 0xFF00 >> 8),
                    (byte)(map_id & 0xFF),
                    (byte)(this.getServiceId() & 0xFF00 >> 8),
                    (byte)(this.getServiceId() & 0xFF)
            });
        } catch (Exception e) {
            //이미 다른 서비스가 생성함
        }
    }

    public void receiveServiceMessage(ServiceImpl sender, Packet packet) {
        getLogger().info("메시지가 왔어요!!!! 아마 맵정보 요청이겠죠?");
    }
}
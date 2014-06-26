package bluesky.server.mapservice;

import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.service.GetMapInfo;
import bluesky.protocol.packet.service.ServiceBreakTile;
import bluesky.protocol.packet.service.ServicePickUpItem;
import bluesky.server.mapservice.generator.IMapTilesGenerator;
import bluesky.server.service.Service;
import bluesky.server.service.ServiceImpl;
import bluesky.server.usersevice.MapProxy;
import org.apache.zookeeper.CreateMode;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.util.HashMap;

public class MapService extends Service {
    private HashMap<Integer, Map>[] maps;
    private IMapTilesGenerator generator;

    public MapService(short id, String address, IMapTilesGenerator generator) {
        this.generator = generator;
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

    protected void arrivedMQTTMessage(String topic, final MqttMessage message) {
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
            return;
        }

        if(topic.startsWith("/maps/")) {
            String subTopic = topic.substring(6);
            int mapIdEndIndex = subTopic.indexOf("/");
            final int mapId = Integer.valueOf(subTopic.substring(0, mapIdEndIndex));
            subTopic = subTopic.substring(mapIdEndIndex);
            final String finalSubTopic = subTopic;
            this.addWork(mapId, new Runnable() {
                @Override
                public void run() {
                    HashMap<Integer, Map> localMaps = maps[getWorkerIndex(mapId)];
                    if(!localMaps.containsKey(mapId)) {
                        return;
                    }
                    Map map = localMaps.get(mapId);
                    map.arrivedMQTTMessage(finalSubTopic, message.getPayload());
                }
            });
            return;
        }
        if(topic.startsWith("/event/create_map/")) {
            byte[] data = message.getPayload();

            final int mapId = Integer.valueOf(topic.substring(18));
            int targetMapId = 0;
            int targetMapPosition = 0;
            targetMapId |= data[0] << 24;
            targetMapId |= data[1] << 16;
            targetMapId |= data[2] << 8;
            targetMapId |= data[3];
            targetMapPosition |= data[4];

            final int finalTargetMapId = targetMapId;

            final int finalTargetMapPosition = targetMapPosition;
            this.addWork(mapId, new Runnable() {
                @Override
                public void run() {
                    HashMap<Integer, Map> localMaps = maps[getWorkerIndex(mapId)];
                    if(!localMaps.containsKey(mapId)) {
                        return;
                    }
                    Map map = localMaps.get(mapId);
                    map.linkAroundMap(finalTargetMapId, finalTargetMapPosition);
                }
            });
            return;
        }
    }

    private void linkMap(int map_id) {
        try {
            this.getZooKeeperClient().create()
                    .withMode(CreateMode.EPHEMERAL)
                    .forPath("/maps/" + map_id, new byte[]{
                            (byte) ((this.getServiceId() & 0xFF00) >> 8),
                            (byte) ((this.getServiceId() & 0xFF))
                    });
            this.maps[getWorkerIndex(map_id)].put(map_id, new Map(this, map_id));
            this.subscribeMQTT("/maps/" + map_id + "/#");
            this.subscribeMQTT("/event/create_map/" + map_id);
            this.publishMQTT("/event/link_map", new byte[]{
                    (byte)((map_id & 0xFF000000) >> 24),
                    (byte)((map_id & 0xFF0000) >> 16),
                    (byte)((map_id & 0xFF00) >> 8),
                    (byte)(map_id & 0xFF),
                    (byte)((this.getServiceId() & 0xFF00) >> 8),
                    (byte)(this.getServiceId() & 0xFF)
            });
        } catch (Exception e) {
            //이미 다른 서비스가 생성함
        }
    }

    public void receiveServiceMessage(final ServiceImpl sender, Packet packet) {
        if(packet instanceof GetMapInfo) {
            final GetMapInfo getMapInfo = (GetMapInfo)packet;
            this.addWork(getMapInfo.map_id, new Runnable() {
                @Override
                public void run() {
                    HashMap<Integer, Map> localMaps = maps[getWorkerIndex(getMapInfo.map_id)];
                    if(!localMaps.containsKey(getMapInfo.map_id)) {
                        return;
                    }
                    Map map = localMaps.get(getMapInfo.map_id);
                    map.getMapInfo(sender, getMapInfo);
                }
            });
        }

        if(packet instanceof ServiceBreakTile) {
            final ServiceBreakTile serviceBreakTile = (ServiceBreakTile)packet;
            this.addWork(serviceBreakTile.map_id, new Runnable() {
                @Override
                public void run() {
                    HashMap<Integer, Map> localMaps = maps[getWorkerIndex(serviceBreakTile.map_id)];
                    if(!localMaps.containsKey(serviceBreakTile.map_id)) {
                        return;
                    }
                    Map map = localMaps.get(serviceBreakTile.map_id);
                    map.breakTile(serviceBreakTile.x, serviceBreakTile.y);
                }
            });
        }

        if(packet instanceof ServicePickUpItem) {
            final ServicePickUpItem pickUpItem = (ServicePickUpItem)packet;
            this.addWork(pickUpItem.map_id, new Runnable() {
                @Override
                public void run() {
                    HashMap<Integer, Map> localMaps = maps[getWorkerIndex(pickUpItem.map_id)];
                    if(!localMaps.containsKey(pickUpItem.map_id)) {
                        return;
                    }
                    Map map = localMaps.get(pickUpItem.map_id);
                    map.pickUpItem(pickUpItem.object_id);
                }
            });
        }
    }

    public IMapTilesGenerator getMapGenerator() {
        return this.generator;
    }
}
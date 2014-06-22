package bluesky.server.usersevice;

import bluesky.protocol.NetworkDecoder;
import bluesky.protocol.NetworkEncoder;
import bluesky.protocol.packet.client.ClientPacketList;
import bluesky.protocol.packet.client.MoveObject;
import bluesky.server.service.Service;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.*;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

import java.net.InetSocketAddress;
import java.util.HashMap;
import java.util.concurrent.Executors;

public class UserService extends Service {
    private ClientPacketList packetList = new ClientPacketList();
    private HashMap<Integer, MapProxy>[] maps;

    public UserService(short id, String address) {
        this.setServiceInfo(id, address, 8000 + id);
    }

    public void start() {
        this.init();
        this.maps = new HashMap[this.getWorkerCount()];
        for(int i=0; i<this.maps.length; i++) {
            this.maps[i] = new HashMap<Integer, MapProxy>();
        }
        this.subscribeMQTT("/event/link_map");

        ChannelFactory factory = new NioServerSocketChannelFactory(Executors.newCachedThreadPool(),
                Executors.newCachedThreadPool());

        ServerBootstrap b = new ServerBootstrap(factory);
        b.setPipelineFactory(new ChannelPipelineFactory() {
            @Override
            public ChannelPipeline getPipeline() throws Exception {
                ChannelPipeline pipeline = Channels.pipeline();
                pipeline.addLast("decoder", new NetworkDecoder(packetList));
                pipeline.addLast("encoder", new NetworkEncoder(packetList));
                pipeline.addLast("handler", new UserHandler(UserService.this));
                return pipeline;
            }
        });
        b.setOption("child.tcpNoDelay", true);
        b.setOption("child.keepAlive", true);
        b.bind(new InetSocketAddress(7000 + this.getServiceId()));
    }

    private MapProxy getMapProxy(int mapId, boolean n) {
        HashMap<Integer, MapProxy> localMaps = maps[getWorkerIndex(mapId)];
        if(!localMaps.containsKey(mapId)) {
            if(!n) return null;

            MapProxy newMap = new MapProxy(UserService.this, mapId);
            localMaps.put(mapId, newMap);
            newMap.linkMap();
        }
        return localMaps.get(mapId);
    }

    public void loginUser(final UserObject user) {
        final int mapId = user.getMapId();

        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, true);
                user.moveMap(map, user.getX(), user.getY());
            }
        });
    }

    protected void arrivedMQTTMessage(String topic, final MqttMessage message) {
        if(topic.equals("/event/link_map")) {
            byte[] mapIdBytes = message.getPayload();
            int map_id = 0;
            short service_id = 0;
            map_id |= mapIdBytes[0] << 24;
            map_id |= mapIdBytes[1] << 16;
            map_id |= mapIdBytes[2] << 8;
            map_id |= mapIdBytes[3];
            service_id |= mapIdBytes[4] << 8;
            service_id |= mapIdBytes[5];
            final int finalMap_id = map_id;
            final short finalService_id = service_id;

            this.addWork(map_id, new Runnable() {
                @Override
                public void run() {
                    MapProxy map = getMapProxy(finalMap_id, false);
                    if(map == null) return;
                    map.linkService(finalService_id);
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
                    MapProxy map = getMapProxy(mapId, false);
                    if(map == null) return;
                    map.arrivedMQTTMessage(finalSubTopic, message.getPayload());
                }
            });
        }
    }

    public void exitUser(final UserObject user) {
        final int mapId = user.getMapId();
        this.addWork(user.getMapId(), new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, false);
                if(map == null) return;
                map.exitUser(user);
            }
        });
    }

    public void getMapInfo(final UserObject user, final int mapId) {
        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, false);
                if(map == null) return;
                map.sendMapInfo(user);
            }
        });
    }

    public void moveObject(final UserObject user, final MoveObject packet) {
        this.addWork(packet.src_map, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(packet.src_map, false);
                if(map == null) return;
                map.moveObject(user, packet);
            }
        });

        if(packet.src_map == packet.dest_map) return;

        this.addWork(packet.dest_map, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(packet.dest_map, false);
                if(map == null) return;
                map.moveObject(user, packet);
            }
        });
    }
}

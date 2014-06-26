package bluesky.server.usersevice;

import bluesky.protocol.NetworkDecoder;
import bluesky.protocol.NetworkEncoder;
import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.client.*;
import bluesky.protocol.packet.service.MapInfo;
import bluesky.server.service.Service;
import bluesky.server.service.ServiceImpl;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.*;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

import java.net.InetSocketAddress;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.concurrent.Executors;

public class UserService extends Service {
    private ClientPacketList packetList = new ClientPacketList();
    private HashMap<Integer, MapProxy>[] maps;
    private LinkedList<UserObject> users = new LinkedList<UserObject>();

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

        this.addWork(0, new Runnable() {
            @Override
            public void run() {
                users.add(user);
            }
        });
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

        this.addWork(0, new Runnable() {
            @Override
            public void run() {
                users.remove(user);
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

    public void getMapInfo(final UserObject user, final int mapId) {
        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, true);
                if(map == null) return;
                map.sendMapInfo(user);
            }
        });
    }

    public void moveObject(final UserObject user, final MoveObject packet) {
        this.addWork(/*packet.src_map*/user.getMapId(), new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(user.getMapId(), false);
                if(map == null) return;
                map.moveObject(user, packet);
            }
        });

        if(user.getMapId() == packet.dest_map) return;

        this.addWork(packet.dest_map, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(packet.dest_map, true);
                if(map == null) return;
                map.moveObject(user, packet);
            }
        });
    }

    public void receiveServiceMessage(final ServiceImpl sender, final Packet packet) {
        if(packet instanceof MapInfo) {
            final MapInfo info = (MapInfo)packet;
            this.addWork(info.request_map_id, new Runnable() {
                @Override
                public void run() {
                    MapProxy map = getMapProxy(info.request_map_id, false);
                    if(map == null) return;
                    map.responseMapInfo(info);
                }
            });
        }
    }

    public void getObjectInfo(final UserObject user, final CS_GetObjectInfo packet) {
        this.addWork(packet.map_id, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(packet.map_id, false);
                if(map == null) return;
                map.getObjectInfo(user, packet.object_id);
            }
        });
    }

    public void chat(final UserObject user, String msg) {
        final Chat chat = new Chat(user.getMapId(), user.getUUID(), msg);
        final int mapId = user.getMapId();
        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, false);
                if(map == null) return;
                map.sendChat(chat);
            }
        });
    }

    public void breakTile(final UserObject user, final int mapId, final int x, final int y) {
        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, false);
                if(map == null) return;
                map.breakTile(user, x, y);
            }
        });
    }

    public void pickUpItem(final UserObject user, final int mapId, final long objectId) {
        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, false);
                if(map == null) return;
                map.pickUpItem(user, objectId);
            }
        });
    }

    public void setTile(final UserObject user, final int mapId, final int x, final int y, final byte resId) {
        this.addWork(mapId, new Runnable() {
            @Override
            public void run() {
                MapProxy map = getMapProxy(mapId, false);
                if(map == null) return;
                map.setTile(user, x, y, resId);
            }
        });
    }
}

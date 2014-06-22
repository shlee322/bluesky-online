package bluesky.server.service;

import bluesky.protocol.packet.Packet;

public interface ServiceImpl {
    short getServiceId();
    String getServiceType();
    void sendServiceMessage(ServiceImpl sender, Packet packet);
    void receiveServiceMessage(ServiceImpl sender, Packet packet);
}

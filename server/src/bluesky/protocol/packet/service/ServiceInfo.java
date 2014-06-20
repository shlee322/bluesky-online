package bluesky.protocol.packet.service;

import org.msgpack.annotation.Message;
import bluesky.protocol.packet.Packet;
import bluesky.server.service.ServiceImpl;

@Message
public class ServiceInfo implements Packet {
    public short serviceId;
    public String serviceType;

    @Override
    public byte getPacketId() {
        return 1;
    }

    public ServiceInfo() {}
    public ServiceInfo(ServiceImpl service) {
        this.serviceId = service.getServiceId();
        this.serviceType = service.getServiceType();
    }
}

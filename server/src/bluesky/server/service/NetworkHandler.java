package bluesky.server.service;

import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.service.ServiceInfo;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;

import java.rmi.Remote;

public class NetworkHandler extends SimpleChannelUpstreamHandler {
    private ServiceImpl service;
    private static Logger logger = LogManager.getLogger("ServiceHandler");

    public NetworkHandler(ServiceImpl service) {
        this.service = service;
    }

    @Override
    public void channelConnected(org.jboss.netty.channel.ChannelHandlerContext ctx, org.jboss.netty.channel.ChannelStateEvent e) {
        if(this.service instanceof RemoteService) {
            ctx.getChannel().write(new ServiceInfo(((RemoteService)this.service).getService()));
            ((RemoteService)this.service).setChannel(ctx.getChannel());
        } else {
            logger.info("Connent Service " + this.service.getServiceId() + " <- " + ctx.getChannel().getRemoteAddress().toString());
        }
    }

    @Override
    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {
        Packet msg = (Packet)e.getMessage();

        if(msg instanceof ServiceInfo) { //Client -> Server
            ServiceInfo info = (ServiceInfo)msg;
            if(this.service instanceof Service) {
                logger.info("Received ServiceInfo " + service.getServiceId() + " <- " + info.serviceId + "(" + ctx.getChannel().getRemoteAddress() + ")");
                ((Service)service).setRemoteService(info.serviceId, ctx);
            }
            return;
        } else {
            ServiceImpl s = this.service;
            if(this.service instanceof RemoteService) {
                s = ((RemoteService)service).getService();
            }
            s.receiveServiceMessage(service, msg);
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
        logger.warn("Exception Caught Handler", e.getCause());
    }
}
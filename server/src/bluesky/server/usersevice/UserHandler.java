package bluesky.server.usersevice;

import bluesky.protocol.packet.client.SC_Notify;
import org.jboss.netty.channel.*;

public class UserHandler extends SimpleChannelUpstreamHandler {
    public UserHandler(UserService service) {
    }

    public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws java.lang.Exception {
        ctx.getChannel().write(new SC_Notify("서버 공지사항 테스트", 60*3));
    }

    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws java.lang.Exception {
    }

    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {
    }

    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
    }
}
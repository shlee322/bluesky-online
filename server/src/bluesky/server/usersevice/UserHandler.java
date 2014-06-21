package bluesky.server.usersevice;

import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.client.CS_GetMapInfo;
import bluesky.protocol.packet.client.CS_Join;
import bluesky.protocol.packet.client.CS_Login;
import bluesky.protocol.packet.client.SC_Notify;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jboss.netty.channel.*;

public class UserHandler extends SimpleChannelUpstreamHandler {
    private static Logger logger = LogManager.getLogger("UserService");
    private UserService service;
    private UserObject user;

    public UserHandler(UserService service) {
        this.service = service;
    }

    public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws java.lang.Exception {
        logger.info("클라이언트 접속 - " + e.getChannel().getRemoteAddress());
        ctx.getChannel().write(new SC_Notify("서버 공지사항 테스트", 60*3));
    }

    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws java.lang.Exception {
        logger.info("클라이언트 연결 끊김 - " + e.getChannel().getRemoteAddress());
    }

    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {
        Packet packet = (Packet)e.getMessage();

        if(this.user == null) {
            if (packet instanceof CS_Join) {
                ctx.getChannel().write(new SC_Notify("회원가입 실패", 120));
                return;
            }

            if (packet instanceof CS_Login) {
                ctx.getChannel().write(new SC_Notify("로그인 성공", 40));

                this.user = new UserObject(this.service, ctx.getChannel(), ((CS_Login) packet).id);
                this.service.loginUser(this.user);
            }
        } else {
            if(packet instanceof CS_GetMapInfo) {
                CS_GetMapInfo getMapInfo = (CS_GetMapInfo)packet;

                this.service.getMapInfo(this.user, getMapInfo.map_id);
            }
        }
    }

    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
    }
}
package bluesky.server.usersevice;

import bluesky.protocol.packet.Packet;
import bluesky.protocol.packet.client.*;
import bluesky.server.db.DBManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jboss.netty.channel.*;

import java.sql.*;

public class UserHandler extends SimpleChannelUpstreamHandler {
    private static Logger logger = LogManager.getLogger("UserService");
    private UserService service;
    private UserObject user;

    public UserHandler(UserService service) {
        this.service = service;
    }

    public void channelConnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws java.lang.Exception {
        logger.info("클라이언트 접속 - " + e.getChannel().getRemoteAddress());
        //ctx.getChannel().write(new SC_Notify("서버 공지사항 테스트", 60*3));
    }

    public void channelDisconnected(ChannelHandlerContext ctx, ChannelStateEvent e) throws java.lang.Exception {
        logger.info("클라이언트 연결 끊김 - " + e.getChannel().getRemoteAddress());
        if(this.user != null) {
            this.service.exitUser(this.user);
        }
    }

    public void messageReceived(ChannelHandlerContext ctx, MessageEvent e) {
        Packet packet = (Packet)e.getMessage();

        if(this.user == null) {
            if (packet instanceof CS_Join) {
                try {
                    Connection conn = DBManager.getInstance().getConnection();
                    PreparedStatement statement =
                            conn.prepareStatement("INSERT INTO `users` (`user_id`,`user_pw`,`user_name`) VALUES(?, SHA1(?), ?);");

                    statement.setString(1, ((CS_Join) packet).id);
                    statement.setString(2, ((CS_Join) packet).pw);
                    statement.setString(3, ((CS_Join) packet).name);

                    if(statement.executeUpdate() > 0) {
                        ctx.getChannel().write(new SC_Notify("회원가입 성공", 60));
                    }
                    statement.close();
                    conn.close();
                } catch (SQLException e1) {
                    logger.warn("DB 에러가 발생하였습니다.", e1);
                    ctx.getChannel().write(new SC_Notify("중복된 아이디가 존재합니다", 60));
                }
                return;
            }

            if (packet instanceof CS_Login) {
                try {
                    Connection conn = DBManager.getInstance().getConnection();
                    PreparedStatement statement =
                            conn.prepareStatement("SELECT * FROM `users` WHERE `user_id`=? and `user_pw`=SHA1(?);");

                    statement.setString(1, ((CS_Login) packet).id);
                    statement.setString(2, ((CS_Login) packet).pw);

                    ResultSet result = statement.executeQuery();
                    if(result.next()) {
                        ctx.getChannel().write(new SC_Notify("로그인 성공", 40));

                        this.user = new UserObject(this.service, ctx.getChannel(),
                                result.getString("user_name"), result.getInt("map_id"),
                                result.getInt("x"), result.getInt("y"));
                        this.service.loginUser(this.user);
                    } else {
                        ctx.getChannel().write(new SC_Notify("아이디 혹은 비밀번호가 다릅니다.", 120));
                    }

                    result.close();
                    statement.close();
                    conn.close();
                } catch (SQLException e1) {
                    logger.warn("DB 에러가 발생하였습니다.", e1);
                    ctx.getChannel().write(new SC_Notify("로그인 도중 에러가 발생하였습니다.", 120));
                }

                return;
            }
        } else {
            if(packet instanceof CS_GetMapInfo) {
                CS_GetMapInfo getMapInfo = (CS_GetMapInfo)packet;
                this.service.getMapInfo(this.user, getMapInfo.map_id);
                return;
            }

            if(packet instanceof CS_GetObjectInfo) {
                this.service.getObjectInfo(this.user, (CS_GetObjectInfo)packet);
                return;
            }

            if(packet instanceof MoveObject) {
                ((MoveObject) packet).object_id = this.user.getUUID();
                this.service.moveObject(this.user, (MoveObject)packet);
            }

            if(packet instanceof Chat) {
                this.service.chat(this.user, ((Chat)packet).msg);
            }

            if(packet instanceof BreakTile) {
                this.service.breakTile(this.user,
                        ((BreakTile)packet).map_id, ((BreakTile)packet).x, ((BreakTile)packet).y);
            }
        }
    }

    public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
        logger.warn("UserHandler Error", e);
    }
}
package bluesky.server.usersevice;

import org.jboss.netty.channel.SimpleChannelUpstreamHandler;

public class UserHandler extends SimpleChannelUpstreamHandler {
    public UserHandler(UserService service) {
    }
}
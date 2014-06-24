package bluesky.server;

import bluesky.server.mapservice.MapService;
import bluesky.server.mapservice.generator.SanghyuckTilesGenerator;
import bluesky.server.mapservice.generator.YunJeongTilesGenerator;
import bluesky.server.usersevice.UserService;

public class Server {
    public static void main(String[] args) {
        if(args.length < 3) {
            System.err.println("args : [Service] [Id] [IP]");
            return;
        }
/*
        if("user".equals(args[0].toLowerCase())) {
            new UserService(Short.decode(args[1]), args[1]).start();
        }*/

        new UserService((short)1, "183.96.22.222").start();
        new MapService((short)2, "183.96.22.222", new YunJeongTilesGenerator()).start();
        //new UserService((short)2, "127.0.0.1").start();
        //new UserService((short)3, "127.0.0.1").start();
    }
}

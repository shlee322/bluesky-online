package bluesky.server;

import bluesky.server.map.MapManager;
import bluesky.server.network.NetworkManager;

import java.io.File;

public class Server {
    public static void main(String[] args) {
        MapManager.getInstance().setDirectory(new File("./maps/"));
        MapManager.getInstance().start();
        NetworkManager.getInstance().start();
    }
}

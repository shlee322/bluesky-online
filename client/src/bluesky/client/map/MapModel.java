package bluesky.client.map;

import bluesky.client.engine.Model;
import bluesky.client.engine.Scene;

import java.util.HashMap;

public class MapModel implements Model {
    private static MapModel instance;
    public static MapModel getInstance() {
        if(instance == null) {
            instance = new MapModel();
        }

        return instance;
    }

    private Map centerMap;
    private HashMap<Long, Map> cacheMap;

    @Override
    public void init(Scene scene) {

    }

    @Override
    public void release(Scene scene) {

    }
}

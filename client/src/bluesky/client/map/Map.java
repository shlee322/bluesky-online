package bluesky.client.map;

import java.util.HashMap;
import java.util.LinkedList;

public class Map {
    private Tile[] tiles = new Tile[20*20];

    //드로우용으로 빠른 for를 위해 제공
    private LinkedList<GameObject> objectList = new LinkedList<GameObject>();
    //네트워크로 캐릭터 이동 등을 제어하기 위하여 사용
    private HashMap<Long, GameObject> objectMap = new HashMap<Long, GameObject>();

    public void addGameObject(GameObject obj) {
        objectList.add(obj);
        objectMap.put(obj.getId(), obj);
    }

    public void removeGameObject(GameObject obj) {
        objectList.remove(obj);
        objectMap.remove(obj);
    }
}

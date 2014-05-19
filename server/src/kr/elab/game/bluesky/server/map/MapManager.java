package kr.elab.game.bluesky.server.map;

import java.util.*;
import java.util.Map;

public class MapManager {
    private static MapManager instance = new MapManager();
    public static MapManager getInstance() { return instance; }

    //차후 스래드 별로 별도처리
    private HashMap<Integer, IMap> maps = new HashMap<Integer, IMap>();

    //맵 생성 스래드에서만 접근 (큐를 이용해서 맵 순차 생성)
    private LinkedList<IMap> mapList = new LinkedList<IMap>();

    private int mapCount = 0;

    public IMap getMap(int id) {
        return null;
    }

    //없는 맵 검사용에만 사용
    public IMap getMap(int world, int x, int y) {
        for(IMap map : mapList) {
            if(map.getWorld() == world && map.getX() == x && map.getY() == y) {
                return map;
            }
        }

        return null;
    }

    public void createMap(int world, int x, int y, IMapTilesGenerator generator) {
        if(this.getMap(world, x, y) != null) {
            return;
        }

        IMap map = new kr.elab.game.bluesky.server.map.Map(mapCount++, world, x, y);
        for(int i=0; i<8; i++) {
            setAroundMap(map, i);
        }

        generator.generate(map);

        mapList.add(map);
    }

    private int getRelativeX(int position) {
        if(position>7 || position<0) {
            return 0;
            //throw new Exception("상대 범위 초과");
        }
        if(position>4) return -1;
        if(position==4) return 0;
        if(position>0) return 1;
        return 0;
    }

    private int getRelativeY(int position) {
        if(position>7 || position<0) {
            return 0;
            //throw new Exception("상대 범위 초과");
        }
        if(position<2) return -1;
        if(position==2) return 0;
        if(position<6) return +1;
        if(position==6) return 0;
        return -1;
    }

    private void setAroundMap(IMap map, int position) {
        if(position>7 || position<0) {
            return;
            //throw new Exception("상대 범위 초과");
        }

        int x = getRelativeX(position);
        int y = getRelativeX(position);

        IMap aroundMap = getMap(map.getWorld(), map.getX() + x, map.getY() + y);

        map.setAroundMap(position, aroundMap);
        if(aroundMap != null) {
            /*
            0 -> 4
            1 -> 5
            2 -> 6
            3 -> 7
            4 -> 0
            5 -> 1
            6 -> 2
            7 -> 3
             */
            aroundMap.setAroundMap(position<4 ? position+4 : position-4, map);
        }


    }
}

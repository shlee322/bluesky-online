package kr.elab.game.bluesky.server.test;

import kr.elab.game.bluesky.server.map.IMap;
import kr.elab.game.bluesky.server.map.IMapTilesGenerator;
import kr.elab.game.bluesky.server.map.MapManager;

public class MapTest {
    public static void main(String[] args) {
        IMapTilesGenerator generator = new IMapTilesGenerator() {
            @Override
            public void generate(IMap map) {
                IMap leftMap = map.getAroundMap(IMap.AroundPosition.LEFT);
                int[] tiles = map.getTilesData();

                System.out.println("타일 생성 요청됨!");

                if(leftMap != null) {
                    System.out.println("왼쪽에 맵이 있네?");
                    leftMap.getTilesData(); //왼쪽맵 타일
                }
            }
        };

        MapManager.getInstance().createMap(0, 0, 0, generator);
        MapManager.getInstance().createMap(0, 1, 0, generator);
        MapManager.getInstance().createMap(0, -1, 0, generator);
        MapManager.getInstance().createMap(0, 0, 1, generator);
        MapManager.getInstance().createMap(0, 0, -1, generator);
        MapManager.getInstance().createMap(0, -1, -1, generator);
        MapManager.getInstance().createMap(0, 1, -1, generator);


        //기준 맵에 대해서 프린트
        PrintMap.print(MapManager.getInstance().getMap(0, 0, 0));
    }
}

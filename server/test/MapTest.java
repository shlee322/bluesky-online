import bluesky.server.map.IMap;
import bluesky.server.map.IMapTilesGenerator;
import bluesky.server.map.MapManager;

public class MapTest {
    public static void main(String[] args) {
        IMapTilesGenerator generator = new IMapTilesGenerator() {
            @Override
            public void generate(IMap map) {
                //map.getTile(x, y);
                //map.setTile(x, y, new PrimitiveTile(code));
                System.out.println("타일 생성 요청됨!");

                if(map.getAroundMap(IMap.AroundPosition.LEFT) != null) {
                    System.out.println("왼쪽에 맵이 있네?");
                    //map.getAroundMap(IMap.AroundPosition.LEFT).getTile(x, y); //왼쪽맵 타일
                }
            }
        };

        testTilesGenerator(generator);
    }

    public static void testTilesGenerator(IMapTilesGenerator generator) {
        MapManager.getInstance().createMap(0, 0, 0, generator);
        MapManager.getInstance().createMap(0, 0, 1, generator);
        MapManager.getInstance().createMap(0, 0, -1, generator);
        MapManager.getInstance().createMap(0, 1, 0, generator);
        MapManager.getInstance().createMap(0, -1, 0, generator);
        MapManager.getInstance().createMap(0, -1, -1, generator);
        MapManager.getInstance().createMap(0, 1, -1, generator);
        MapManager.getInstance().createMap(0, 1, 1, generator);
        MapManager.getInstance().createMap(0, -1, 1, generator);

        //기준 맵에 대해서 프린트
        PrintMap.print(MapManager.getInstance().getMap(0, 0, 0));
    }
}

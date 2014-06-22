import bluesky.server.map.IMap;
import bluesky.server.map.IMapTilesGenerator;
import bluesky.server.map.PrimitiveTile;

import java.util.Random;

public class DankiTilesGenerator implements IMapTilesGenerator {
    @Override
    public void generate(IMap map) {
        if (map.getY() < 0) {
            for (int y = 11; y < 20; y++) {
                for (int x = 0; x < 20; x++) {
                    map.setTile(x, y, PrimitiveTile.getPrimitiveTile(5));

                }
            }
            try {
                mountain(map);
            } catch (Exception e) {
                System.out.println(map + " is full block");
            }
        }
    }

    public static void mountain(IMap map) {
        boolean mt_condition = true;
        Random generator = new Random();
        int boundary = Integer.parseInt(map.getBoundary());
        if (mt_condition) {
            int height = generator.nextInt(boundary); //산 높이
            int mt_center = (int) (Math.random() * 20); //산 중심 축
            int floor = 0;
            for (; height > -1; height--) {
                map.setTile(mt_center, boundary - height, PrimitiveTile.getPrimitiveTile(7)); // 꼭대기 세우기

                for (int temp_floor = floor; temp_floor > 0; temp_floor--) {
                    if (mt_center - temp_floor > -1) {
                        map.setTile(mt_center - temp_floor, boundary - height, PrimitiveTile.getPrimitiveTile(7));
                    } else {
                    } //왼쪽 맵 생성
                    if (mt_center + temp_floor < 20) {
                        map.setTile(mt_center + temp_floor, boundary - height, PrimitiveTile.getPrimitiveTile(7));
                    } else {
                    } // 오른쪽 맵 생성
                }
                floor++;
            }
        }
    }

    public static void main(String[] args) {
        MapTest.testTilesGenerator(new DankiTilesGenerator());
    }
}

import bluesky.server.map.IMap;
import bluesky.server.map.IMapTilesGenerator;
import bluesky.server.map.PrimitiveTile;

import java.util.Random;

public class SanghyuckTilesGenerator implements IMapTilesGenerator {
    private Random r = new Random();

    @Override
    public void generate(IMap map) {
        if(map.getY()<0) {
            for(int y=0; y<20; y++) {
                for(int x=0; x<20; x++) {
                    map.setTile(x, y, PrimitiveTile.getPrimitiveTile(5));
                }
            }
        } else if(map.getY() == 0) {
            for(int y=11; y<20; y++) {
                for(int x=0; x<20; x++) {
                    map.setTile(x, y, PrimitiveTile.getPrimitiveTile(y == 11 ? 3
                            : y == 12 || (y == 13 && r.nextFloat() < 0.8) || (y == 14 && r.nextFloat() < 0.4) ? 2
                            : 5));
                }
            }
        }

        if(map.getY()>0) return;
        int count = r.nextInt(100);

        for(int i=0; i<count; i++) {
            int type = r.nextInt(40);
            int x = r.nextInt(20);
            int y = r.nextInt(20);
            if(map.getY()==0 && y < 12) continue;

            if(type < 3) { //동굴 생성
                create(map, x, y, 0, 0.8f, 0.2f);
            } else if(type < 5) { //물 생성
                create(map, x, y, 1, 0.6f, 0.1f);
            } else if(type < 10) { //기반암 다시 생성
                create(map, x, y, 5, 0.8f, 0.2f);
            } else if(type<20) { //철 생성
                create(map, x, y, 6, 0.8f, 0.2f);
            } else if(type<30) { //석탄 생성
                create(map, x, y, 9, 0.6f, 0.2f);
            } else if(type<40) { //금 생성
                create(map, x, y, 7, 0.1f, 0.01f);
            } else { //다이아 생성
                create(map, x, y, 10, 0.05f, 0.01f);
            }
        }
    }

    private void create(IMap map, int x, int y, int id, float n, float dn) {
        if(r.nextFloat() > n)
            return;


        if(id == 1 && (map.getY() > 0 || (map.getY() == 0 && y < 12))) //물 공중 막음
            return;

        if(x<0 || x>=20 || y<0 || y>=20) //타일 범위 초과
            return;

        map.setTile(x, y, PrimitiveTile.getPrimitiveTile(id));

        for(int cx=-1; cx<=1; cx++) {
            for(int cy=-1; cy<=1; cy++) {
                create(map, x+cx, y+cy, id, n-dn, dn);
            }
        }
    }

    public static void main(String[] args) {
        MapTest.testTilesGenerator(new SanghyuckTilesGenerator());
    }
}

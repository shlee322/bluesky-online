import bluesky.server.map.IMap;
import bluesky.server.map.IMapTilesGenerator;
import bluesky.server.map.PrimitiveTile;

public class SanghyuckTilesGenerator implements IMapTilesGenerator {
    @Override
    public void generate(IMap map) {
        if(map.getY()>0) {
            for(int y=0; y<20; y++) {
                for(int x=0; x<20; x++) {
                    map.setTile(x, y, PrimitiveTile.getPrimitiveTile(2));
                }
            }
        }
    }

    public static void main(String[] args) {
        MapTest.testTilesGenerator(new SanghyuckTilesGenerator());
    }
}

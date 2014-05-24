import bluesky.server.map.IMap;
import bluesky.server.map.ITile;
import bluesky.server.map.PrimitiveTile;

public class PrintMap {
    public static void print(IMap map) {
        if(map == null) {
            System.out.println("기준 맵이 존재하지 않습니다.");
            return;
        }

        printLineMap(map.getAroundMap(IMap.AroundPosition.UP_LEFT),
                map.getAroundMap(IMap.AroundPosition.UP),
                map.getAroundMap(IMap.AroundPosition.UP_RIGHT));

        printLineMap(map.getAroundMap(IMap.AroundPosition.LEFT),
                map,
                map.getAroundMap(IMap.AroundPosition.RIGHT));

        printLineMap(map.getAroundMap(IMap.AroundPosition.DOWN_LEFT),
                map.getAroundMap(IMap.AroundPosition.DOWN),
                map.getAroundMap(IMap.AroundPosition.DOWN_RIGHT));
    }

    private static IMap noneMap = new NoneMap();

    private static void printLineMap(IMap left, IMap center, IMap right) {
        if(left == null)
            left = noneMap;
        if(center == null)
            center = noneMap;
        if(right == null)
            right = noneMap;

        for(int y=0; y<10; y++) {
            for(int x=0; x<10; x++) {
                System.out.printf("%d ", left.getTile(x, y).getResId());
            }
            for(int x=0; x<10; x++) {
                System.out.printf("%d ", center.getTile(x, y).getResId());
            }
            for(int x=0; x<10; x++) {
                System.out.printf("%d ", right.getTile(x, y).getResId());
            }
            System.out.println();
        }

    }

    private static class NoneMap implements IMap {
        private PrimitiveTile noneTile = PrimitiveTile.getPrimitiveTile(0);

        @Override
        public int getId() {
            return 0;
        }

        @Override
        public int getWorld() {
            return 0;
        }

        @Override
        public int getX() {
            return 0;
        }

        @Override
        public int getY() {
            return 0;
        }

        @Override
        public IMap getAroundMap(int position) {
            return null;
        }

        @Override
        public void setAroundMap(int position, IMap map) {
        }

        @Override
        public ITile getTile(int x, int y) {
            return this.noneTile;
        }

        @Override
        public void setTile(int x, int y, ITile tile) {
        }
    }
}

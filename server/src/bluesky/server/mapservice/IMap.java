package bluesky.server.mapservice;

public interface IMap {
    int getId();
    int getWorld();
    int getX();
    int getY();
    IMap getAroundMap(int position);
    void setAroundMap(int position, IMap map);
    //ITile getTile(int x, int y);
    void setTile(int x, int y, byte tile);

    class AroundPosition {
        public static final int UP=0;
        public static final int UP_RIGHT=1;
        public static final int RIGHT=2;
        public static final int DOWN_RIGHT=3;
        public static final int DOWN=4;
        public static final int DOWN_LEFT=5;
        public static final int LEFT=6;
        public static final int UP_LEFT=7;
    }
}

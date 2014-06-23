package bluesky.server.mapservice;

public interface IMap {
    int getMapId();
    int getMapX();
    int getMapY();
    //IMap getAroundMap(int position);
    void setTile(int x, int y, byte code);
    void save();

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

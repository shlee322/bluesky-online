package kr.elab.game.bluesky.server.map;

public class Map implements IMap {
    private int id;
    private int world;
    private int x;
    private int y;
    private int[] tiles = new int[100];

    public Map(int id, int world, int x, int y) {
        this.id = id;
        this.world = world;
        this.x = x;
        this.y = y;
    }

    @Override
    public int getId() {
        return this.id;
    }

    @Override
    public int getWorld() {
        return this.world;
    }

    @Override
    public int getX() {
        return this.x;
    }

    @Override
    public int getY() {
        return this.y;
    }

    @Override
    public IMap getAroundMap(int position) {
        return null;
    }

    @Override
    public void setAroundMap(int position, IMap map) {
        if(map == null) {

        } else {

        }
    }

    @Override
    public int[] getTilesData() {
        return this.tiles;
    }
}

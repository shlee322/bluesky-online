package kr.elab.game.bluesky.server.map;

public class Map implements IMap {
    private int id;
    private int world;
    private int x;
    private int y;

    private IMap[] aroundMaps = new IMap[8];
    private ITile[] tiles = new ITile[400];

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
        return this.aroundMaps[position];
    }

    @Override
    public void setAroundMap(int position, IMap map) {
        this.aroundMaps[position] = map;
    }

    @Override
    public ITile getTile(int x, int y) {
        ITile tile = this.tiles[20*y+x];
        if(tile == null) {
            tile = PrimitiveTile.getPrimitiveTile(0);
            this.tiles[20*y+x] = tile;
        }

        return tile;
    }

    @Override
    public void setTile(int x, int y, ITile tile) {
        this.tiles[20*y+x] = tile;
    }
}

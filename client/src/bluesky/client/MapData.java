package bluesky.client;

import java.util.ArrayList;

public class MapData {
    //size : 25 * 25 (32*)
    private final int WIDTH_CENTER = 800 / 2;
    private final int HEIGHT_CENTER = 400 / 2;
    private final int MAP_SIZE = 20;
    private final int MAP_PX_SIZE = MAP_SIZE * 32;

    private MapScene map;
    private int position;

    private MapTile[] tiles = new MapTile[MAP_SIZE * MAP_SIZE];
    private ArrayList<GameObject> objects;

    public MapData(MapScene map) {
        this.map = map;
        this.objects = new ArrayList<GameObject>();
    }

    public void setMapPosition(int position) {
        this.position = position;
    }

    public void setTile(int x, int y, int id) {
        this.tiles[y * MAP_SIZE + x] = id != -1 ? new MapTile(this, x, y) : null;
    }

    public MapTile getTile(int x, int y) {
        int ind = y * MAP_SIZE + x;
        if (ind < 0 || ind >= tiles.length) return null;
        return this.tiles[ind];
    }

    public void addObject(GameObject c) {
        this.objects.add(c);
    }

    public int getX() {
        int p = (this.position == MapScene.MapPosition.CENTER ? 0
                : this.position == MapScene.MapPosition.LEFT ? -1 * MAP_PX_SIZE
                : this.position == MapScene.MapPosition.UP ? 0
                : this.position == MapScene.MapPosition.RIGHT ? MAP_PX_SIZE
                : this.position == MapScene.MapPosition.DOWN ? 0
                : this.position == MapScene.MapPosition.UP_LEFT ? -1 * MAP_PX_SIZE
                : this.position == MapScene.MapPosition.UP_RIGHT ? MAP_PX_SIZE
                : this.position == MapScene.MapPosition.DOWN_LEFT ? -1 * MAP_PX_SIZE
                : this.position == MapScene.MapPosition.DOWN_RIGHT ? MAP_PX_SIZE
                : 0);

        return WIDTH_CENTER - this.map.getCenterX() + p;
    }

    public int getY() {
        int p = (this.position == MapScene.MapPosition.CENTER ? 0
                : this.position == MapScene.MapPosition.LEFT ? 0
                : this.position == MapScene.MapPosition.UP ? -1 * MAP_PX_SIZE
                : this.position == MapScene.MapPosition.RIGHT ? 0
                : this.position == MapScene.MapPosition.DOWN ? MAP_PX_SIZE
                : this.position == MapScene.MapPosition.UP_LEFT ? -1 * MAP_PX_SIZE
                : this.position == MapScene.MapPosition.UP_RIGHT ? -1 * MAP_PX_SIZE
                : this.position == MapScene.MapPosition.DOWN_LEFT ? MAP_PX_SIZE
                : this.position == MapScene.MapPosition.DOWN_RIGHT ? MAP_PX_SIZE
                : 0);

        return HEIGHT_CENTER - this.map.getCenterY() + p;
    }

    public void drawTiles() {
        //xy
        for (int i = 0; i < this.tiles.length; i++) {
            if (this.tiles[i] == null) {
                continue;
            }

            this.tiles[i].draw();
        }
    }

    public void drawObjects() {
        //xy
        for (GameObject obj : this.objects) {
            obj.draw();
        }
    }
}

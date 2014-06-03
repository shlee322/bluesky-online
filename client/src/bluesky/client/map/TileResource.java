package bluesky.client.map;

import bluesky.client.engine.EngineEntity;

/**
 * Tile Resource
 *
 * 타일 강도 등의 데이터를 저장하고 있는 클래스
 */
public class TileResource implements EngineEntity {
    private static int MAX_SIZE = 20;
    private static TileResource[] tileResources = new TileResource[MAX_SIZE];

    public static TileResource getTileResource(int id) {
        return id<0 || id>=tileResources.length ? null : tileResources[id];
    }

    static {
        tileResources[0] = new TileResource();
    }

    private String img;
    private int solidity;
    private boolean overlap;
    private Object engineTag;

    private TileResource() {
    }

    @Override
    public void setEngineTag(Object o) {
        this.engineTag = o;
    }

    @Override
    public Object getEngineTag() {
        return this.engineTag;
    }
}

package bluesky.client.map;

import bluesky.client.engine.EngineEntity;

public class GameObject implements EngineEntity{
    private Map map;
    private int x;
    private int y;
    private int direction;
    private Object engineTag;

    public long getId() {
        return 0;
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

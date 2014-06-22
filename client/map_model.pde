public static class MapModel implements Model {
	private GameObject myObject; //캐릭터를 의미
	public void init(Scene scene) {}
    public void release(Scene scene) {}
	public void moveMap(int mapId, long objectId) {
		Engine.getInstance().getNetwork().write(new CS_GetMapInfo(mapId));
	}
}

class Map {
}

class Tile {
}

class GameObject {
	private Map map;

	public void setMap(Map map) {
		this.map = map;
	}
	public Map getMap() {
		return this.map;
	}
}
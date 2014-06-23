public static class MapModel implements Model {
	private long myObjectId;
	private GameObject myObject; //캐릭터를 의미
	private HashMap<Integer, Map> cacheMaps = new HashMap<Integer, Map>();
	public void init(Scene scene) {}
    public void release(Scene scene) {}
	public void moveMap(int mapId, long objectId) {
		myObjectId = objectId;
		Engine.getInstance().getNetwork().write(new CS_GetMapInfo(mapId));
	}
	public void setMapInfo(SC_MapInfo info) {
		cacheMaps.put(info.map_id, new Map(info.map_id, info.around_map_id, info.tiles));
	}

    //맵정보를 불러와서 동시에 오브젝트 리스트도 불러왔거나, 캐릭터가 이동했을때
    public void moveObject(MoveObject move) {
    	if(move.object_id != myObjectId) return; //일단 테스트를 위해서 자기 자신의 캐릭터만
    	if(myObject == null) {
    		myObject = new GameObject(move.object_id, move.src_map, move.src_x, move.src_y);
    	}
    }

    public Map getMap(int id) {
    	return cacheMaps.get(id);
    }

    public GameObject getMyObject() {
    	return this.myObject;
    }
}

static class Map {
    //info.map_id int
    //info.around_map_id int[8]
    //info.tiles byte[400]
    private int mapId;
    private int[] aroundMapId;
    private byte[] tiles;
	public Map(int mapId, int[] aroundMapId, byte[] tiles) {
		this.mapId = mapId;
		this.aroundMapId = aroundMapId;
		this.tiles = tiles;
	}

	public byte[] getTiles() {
		return this.tiles;
	}
}

static class Tile {
}

static class GameObject {
	private long uuid;
	private int mapId;
	private int x;
	private int y;

	public GameObject(long uuid, int mapId, int x, int y) {
		this.uuid = uuid;
		this.mapId = mapId;
		this.x = x;
		this.y = y;
	}

	public int getMapId() {
		return this.mapId;
	}

	public int getX() {
		return this.x;
	}

	public int getY() {
		return this.y;
	}
}
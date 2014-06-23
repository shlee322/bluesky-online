public static class MapModel implements Model {
	private long myObjectId;
	private GameObject myObject; //캐릭터를 의미
	private HashMap<Integer, Map> cacheMaps = new HashMap<Integer, Map>();
	private HashMap<Long, GameObject> cacheObject = new HashMap<Long, GameObject>();
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
    	if(!cacheObject.containsKey(move.object_id)) {
    		cacheObject.put(move.object_id, new GameObject(move.object_id, move.src_map, move.src_x, move.src_y));
    	}

    	GameObject obj = cacheObject.get(move.object_id);

    	if(myObject == null) {
    		myObject = obj;
    	}

    	obj.move(move.src_map, move.src_x, move.src_y, move.dest_map, move.dest_x, move.dest_y);
    }

    public void setObjectInfo(SC_ObjectInfo info) {
    	if(!cacheObject.containsKey(info.object_id)) {
    		return;
    	}
    	print("test");

    	GameObject obj = cacheObject.get(info.object_id);
    	obj.setName(info.name);
    }

    public void chat(Chat chat) {
    	if(!cacheObject.containsKey(chat.object_id)) {
    		return;
    	}

    	GameObject obj = cacheObject.get(chat.object_id);
    	obj.setHeadMessage(chat.msg);
    }

    public Map getMap(int id) {
    	if(id == -1) return null;
    	if(!cacheMaps.containsKey(id)) { //캐싱되어있지 않음
    		Engine.getInstance().getNetwork().write(new CS_GetMapInfo(id));
    		return null;
    	}

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
    public int getAroundMapId(int i){
        return this.aroundMapId[i];
    }
}

static class Tile {
}

static class GameObject implements Entity {
	private long uuid;
	private int mapId;
	public int x;
	public int y;
	private Object engineTag;
	private EImage weapon;
	private String name="";
	private String headMessage="";
	public int dest_x;
	public int dest_y;
	public int moveTick=0;
	public int dir = 0;

	public GameObject(long uuid, int mapId, int x, int y) {
		this.uuid = uuid;
		this.mapId = mapId;
		this.x = x;
		this.y = y;
		this.dest_x = x;
		this.dest_y = y;

		print(uuid);
		Engine.getInstance().getNetwork().write(new CS_GetObjectInfo(mapId, uuid));
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

    public void setX(int i){
        this.x-=i;
    } 
    public void setY(int i){
        this.y-=i;
    }
	public void move(int src_map, int src_x, int src_y, int dest_map, int dest_x, int dest_y) {
		this.x = src_x;
		this.y = src_y;
		this.dest_x = dest_x;
		this.dest_y = dest_y;
	}

	public void setEngineTag(Object o) {
		this.engineTag = o;
	}

    public Object getEngineTag() {
    	return this.engineTag;
    }

    public String getName() {
    	return this.name;
    }

    public void setName(String name) {
    	this.name = name;
    }

    public String getHeadMessage() {
    	return this.headMessage;
    }

    public void setHeadMessage(String msg) {
    	this.headMessage = msg;
    }

    public void setWeapon(EImage weapon) {
    	this.weapon = weapon;
    }

    public EImage getWeapon() {
    	return this.weapon;
    }

    public void updateWeapon() {
    	if(this.weapon == null) return;

    	if(this.weapon.getRotate() <= PI/2) {
    		for(int i = 0; i<=30; i++) {
    			this.weapon.setRotate(i*PI/60);
    			((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().rotate(this.weapon.getRotate());
    		}
    	}

    	if(this.weapon.getRotate() == PI/2) {
    		for(int i = 30; i>=0; i--) {
    			this.weapon.setRotate(i*PI/60);
    			((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().rotate(this.weapon.getRotate());
   			}
    	}
    }
}
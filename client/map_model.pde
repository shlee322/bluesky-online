public static class MapModel implements Model {
    private static int TILE_SIZE = 800 / 24; //타일 사이즈 화면에 총 24개의 타일이 출력될 수 있음
    private static int MAP_SIZE = TILE_SIZE * 20; //한 변에 있는 타일 수
    private static MapModel instance = new MapModel();

    public static class MapPosition {
        public static final int CENTER = -1;
        public static final int UP = 0;
        public static final int UP_RIGHT = 1;
        public static final int RIGHT = 2;
        public static final int DOWN_RIGHT = 3;
        public static final int DOWN = 4;
        public static final int DOWN_LEFT = 5;
        public static final int LEFT = 6;
        public static final int UP_LEFT = 7;
    }

    public static int getTileSize() {
        return TILE_SIZE;
    }

    public static MapModel getInstance() {
        return instance;
    }

	private long myObjectId;
	private GameObject myObject; //캐릭터를 의미
	private HashMap<Integer, Map> cacheMaps = new HashMap<Integer, Map>();
	private HashMap<Long, GameObject> cacheObject = new HashMap<Long, GameObject>();
    private Map centerMap;

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

    	if(myObject == null && myObjectId == obj.getUUID()) {
    		myObject = obj;
    	}

    	obj.move(move.src_map, move.src_x, move.src_y, move.dest_map, move.dest_x, move.dest_y);
    }

    public void setObjectInfo(SC_ObjectInfo info) {
    	if(!cacheObject.containsKey(info.object_id)) {
    		return;
    	}

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

    public void breakTile(BreakTile breakTile) {
        Map map = this.getMap(breakTile.map_id);
        if(map == null) return;
        map.setTile(new Tile((byte)0, breakTile.map_id, breakTile.x, breakTile.y));
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

    public Map getCenterMap() {
        if(this.centerMap == null || this.centerMap.getMapId() != this.getMyObject().getMapId()) {
            this.centerMap = this.getMap(this.getMyObject().getMapId());
        }
        return this.centerMap;
    }

    public void updateMapDisplayPosition() {
        Map centerMap = getCenterMap();
        if(centerMap == null) return;

        centerMap.setDisplayPosition(MapPosition.CENTER, centerMap.getMapId());
        for(int i=0; i<8; i++) {
            int mapId = centerMap.getAroundMapId(i);
            if(mapId == -1) continue;
            Map aroundMap = this.getMap(mapId);
            if(aroundMap == null) continue;
            aroundMap.setDisplayPosition(i, centerMap.getMapId());
        }
    }

    public java.util.Set getGameObjects() {
        return this.cacheObject.entrySet();
    }

    private int getPositionX(int position) {
        return (position == MapPosition.LEFT ? -1
          : position == MapPosition.UP ? 0
          : position == MapPosition.RIGHT ? 1
          : position == MapPosition.DOWN ? 0
          : position == MapPosition.UP_LEFT ? -1
          : position == MapPosition.UP_RIGHT ? 1
          : position == MapPosition.DOWN_LEFT ? -1
          : position == MapPosition.DOWN_RIGHT ? 1
          : 0);
    }

    private int getPositionY(int position) {
        return (position == MapPosition.LEFT ? 0
          : position == MapPosition.UP ?  -1
          : position == MapPosition.RIGHT ? 0
          : position == MapPosition.DOWN ? 1
          : position == MapPosition.UP_LEFT ? -1
          : position == MapPosition.UP_RIGHT ? -1
          : position == MapPosition.DOWN_LEFT ? 1
          : position == MapPosition.DOWN_RIGHT ? 1
          : 0);
    }

    public int getDisplayX(int position) {
        int p = this.getPositionX(position) * MAP_SIZE;

        if(position == MapPosition.CENTER) {
            return -1 * MapModel.getTileSize() * this.getMyObject().getX() / 4 + 400 - (this.getMyObject().getWidth()/2);
        }

        return this.getDisplayX(MapPosition.CENTER) + p;
    }

    public int getDisplayY(int position) {
        int p = this.getPositionY(position) * MAP_SIZE;

      if(position == MapPosition.CENTER) {
        return -1*MapModel.getTileSize()*this.getMyObject().getY()/4 + 300 - this.getMyObject().getHeight();
      }

      return this.getDisplayY(MapPosition.CENTER) + p;
    }

    public TilePosition getAroundTilePosition(GameObject obj, int position) {
        int x = ((obj.getX()+4)/4) + this.getPositionX(position);
        int y = ((obj.getY()-1)/4) + this.getPositionY(position);
        if(x<0) return new TilePosition(this.getMap(obj.getMapId()).getAroundMapId(MapPosition.LEFT), 19, y);
        if(x>19) return new TilePosition(this.getMap(obj.getMapId()).getAroundMapId(MapPosition.RIGHT), 0, y);
        return new TilePosition(obj.getMapId(), x, y);
    }
}

/*
타일 하나는 4개의 캐릭터 좌표계와 동일
주인공 좌표

Map.getDisplayX()
Map.getDisplayY()

if(주인공맵 id가 자기와 같다?!) {
}
*/

public static class Map {
    private int mapId;
    private int[] aroundMapId;
    private Tile[] tiles;
    private int position;
    private int centerMapId;

    public Map(int mapId, int[] aroundMapId, byte[] tiles) {
    	this.mapId = mapId;
    	this.aroundMapId = aroundMapId;
        this.tiles = new Tile[tiles.length];
        for(int i=0; i<tiles.length; i++) {
            this.tiles[i] = new Tile(tiles[i], this.mapId, i%20, i/20);
        }
    }

    public int getMapId() {
      return this.mapId;
    }

	public Tile getTile(int x, int y) {
		return this.tiles[y*20+x];
	}

    public void setTile(Tile tile) {
        this.tiles[tile.getY()*20+tile.getX()] = tile;

    }

    public int getAroundMapId(int i){
        return this.aroundMapId[i];
    }

    public void setDisplayPosition(int position, int centerMapId) {
        this.position = position;
        this.centerMapId = centerMapId;
    }

    public int getDisplayPosition() {
        return this.position;
    }

    public boolean isDisplay(GameObject myObject) {
        if(this.centerMapId != myObject.getMapId()) return false;
        return true;
    }
}

public static class TilePosition {
    public int mapId;
    public int x;
    public int y;

    public TilePosition(int mapId, int x, int y) {
        this.mapId = mapId;
        this.x = x;
        this.y = y;
    }
}

public static class Tile {
    private byte resId;
    private int hp = 300;
    private int mapId;
    private int x;
    private int y;
    private boolean drawHp;

    public Tile(byte resId, int mapId, int x, int y) {
        this.resId = resId;
        this.mapId = mapId;
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return this.x;
    }

    public int getY() {
        return this.y;
    }

    public byte getResId() {
        return this.resId;
    }

    public int getMaxHp() {
        return 300;
    }

    public int getHp() {
        return this.hp;
    }

    public String getResName() {
        switch (this.getResId()) {
            case 0 : 
                break;
            case 1 :
                return "water";
            case 2 :
                return "dirt";
            case 3 :
                return "grass";
            case 4 :
                return "sand";
            case 5 :
                return "stone";
            case 6 :
                return "iron_ore";
            case 7 :
                return "gold_ore";
            case 8 :
                return "lava";
            case 9 :
                return "coal_ore";
            case 10 :
                return "diamond_ore";
            case 11 :
                return "clay";
            default :
                break;  
        }
        return null;
    }

    public void breakTile() {
        this.hp -= 1;
        if(hp < 1) {
            if(this.resId != 0) {
                Engine.getInstance().getNetwork().write(new BreakTile(mapId, x, y));
            }
            this.resId = 0;
            this.hp = 0;
        }
    }

    public void setDrawHp(boolean drawHp) {
        this.drawHp = drawHp;
    }

    public boolean isDrawHp() {
        return true;
    }
}

public static class GameObject implements Entity {
	private long uuid;
	private int mapId;
	private int x;
	private int y;
	private Object engineTag;
	private EImage weapon;
	private String name="";
	private String headMessage="";
    private int dest_map_id;
	private int dest_x;
	private int dest_y;
	public int moveTick=0;
    private int width=0;
    private int height=0;
    private int dir;

	public GameObject(long uuid, int mapId, int x, int y) {
		this.uuid = uuid;
		this.mapId = mapId;
		this.x = x;
		this.y = y;
        this.dest_map_id = mapId;
		this.dest_x = x;
		this.dest_y = y;

		Engine.getInstance().getNetwork().write(new CS_GetObjectInfo(mapId, uuid));
	}

    public long getUUID() {
        return this.uuid;
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

    public void setX(int x) {
        this.x = x;
    }

    public void setY(int y) {
        this.y = y;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public int getWidth() {
        return this.width;
    }

    public int getHeight() {
        return this.height;
    }

	public void move(int src_map, int src_x, int src_y, int dest_map_id, int dest_x, int dest_y) {
        this.mapId = src_map;
		this.x = src_x;
		this.y = src_y;
        this.dest_map_id = dest_map_id;
		this.dest_x = dest_x;
		this.dest_y = dest_y;
	}

    public int getDestMapId() {
        return this.dest_map_id;
    }

    public int getDestX() {
        return this.dest_x;
    }

    public int getDestY() {
        return this.dest_y;
    }

    public int getMoveDir() {
        if(this.getDestMapId() == mapId) {
            dir = dest_x > x ? 1 : 0;
            return dir;
        }

        Map destMap = MapModel.getInstance().getMap(this.getDestMapId());
        if(destMap == null) return -1;
        if(this.getDestMapId() == destMap.getAroundMapId(MapModel.MapPosition.LEFT)) {
            dir = 0;
            return 0;
        }
        if(this.getDestMapId() == destMap.getAroundMapId(MapModel.MapPosition.RIGHT)) {
            dir = 1;
            return 1;
        }
        return -1;
    }

    public int getDir() {
        return dir;
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
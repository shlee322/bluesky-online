public static class MapScene implements Scene {
    private MapModel model;

    public MapScene(SC_MoveMap moveMap) {
        if(Engine.getInstance().getScene() instanceof LoginScene) {
            Engine.getInstance().getUIManager().clearComponentList();
        }

        Engine.getInstance().playBGM("data/bgm/map_1.mp3");

        this.model = new MapModel();
        this.model.init(this);
        this.model.moveMap(moveMap.map_id, moveMap.object_id);
    }

    @Override
    public void init() {

    }

    @Override
    public void runSceneLoop() {
        //가시성 있는 Tile 뿌림
        //Engine.getInstance().viewTile();
    }

    @Override
    public void release() {
    }

    @Override
    public void receivedPacket(Packet packet) {
        if(packet instanceof SC_MapInfo) {
            //((SC_MapInfo)packet).map_id int
            //((SC_MapInfo)packet).around_map_id int[8]
            //((SC_MapInfo)packet).tiles byte[400]
        }

        if(packet instanceof MoveObject) {
            //맵정보를 불러와서 동시에 오브젝트 리스트도 불러왔거나, 캐릭터가 이동했을때
        }
    }
}
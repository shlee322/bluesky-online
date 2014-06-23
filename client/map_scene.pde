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
        if(this.model.getMyObject() == null) return;

        //자기 캐릭터에 대해서 상대적으로 타일을 뿌려야함
        //this.model.getMyObject().getX()
        //this.model.getMyObject().getY()

        int tileSize = Engine.getInstance().getWidth() / 24;
        for(int y=0; y<20; y++) {
            for(int x=0; x<20; x++) {
                Engine.getInstance().drawTile(x*tileSize, y*tileSize, "iron_ore"); //픽셀 좌표 x, y, 이미지 명
            }
        }
        
        //가시성 있는 Tile 뿌림
        //Engine.getInstance().viewTile();

        //캐릭터 뿌림 (테스트로 자기만)
        Engine.getInstance().drawGameObject(200, 200, this.model.getMyObject());
    }

    @Override
    public void release() {
    }

    @Override
    public void receivedPacket(Packet packet) {
        if(packet instanceof SC_MapInfo) {
            this.model.setMapInfo(((SC_MapInfo)packet));
        }

        if(packet instanceof MoveObject) {
            this.model.moveObject((MoveObject)packet);
        }
    }
}
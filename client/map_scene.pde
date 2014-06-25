public static class MapScene implements Scene, UIOnClickListener {
    private EImage bg;
    JoyStick joyStick;
    float circleRad = 100;      
    float circleX = 127;        
    float circleY = 473;    
    float circleLeft = circleX-circleRad;
    float circleRight = circleX+circleRad;
    float circleUp = circleY-circleRad;
    float circleDown = circleY+circleRad;
    int LEFT = 1;
    int RIGHT = 2;
    int JUMP = 3;
    MoveCharacter move = new MoveCharacter();
    private final int MAP_SIZE = 20;
    private final int MAP_PX_SIZE = MAP_SIZE*32;

    private Tile nullTile = new Tile((byte)0, -1, -1, -1);

    public MapScene(SC_MoveMap moveMap) {
        this.bg = Engine.getInstance().loadImage("images/sky.png");
        this.bg.setWidth(Engine.getInstance().getWidth());
        this.bg.setHeight(Engine.getInstance().getHeight());

        if(Engine.getInstance().getScene() instanceof LoginScene) {
            Engine.getInstance().getUIManager().clearComponentList();
        }

        Engine.getInstance().playBGM("data/bgm/map_1.mp3");

        MapModel.getInstance().init(this);
        MapModel.getInstance().moveMap(moveMap.map_id, moveMap.object_id);
    }

    @Override
    public void init() {
        Engine.getInstance().getUIManager().clearComponentList();

        UIComponent menuBtnComponent = new MenuBtnComponent();

        UIComponent inventory = new Inventory();
        UIComponent key = new KeyPressed();
        //loginBtnComp.setOnClickListener(this);
        menuBtnComponent.setOnClickListener(this);
        inventory.setOnClickListener(this);
        Engine.getInstance().getUIManager().addComponent(menuBtnComponent);
        Engine.getInstance().getUIManager().addComponent(inventory);
        Engine.getInstance().getUIManager().addComponent(key);
        joyStick = new JoyStick();

        ChatBox chat = new ChatBox();
        chat.emptyText = "메시지를 입력하려면 이곳을 클릭하세요.";
        chat.x = 0;
        chat.y = 550;
        chat.width = 800;
        chat.yy = 30;
        Engine.getInstance().getUIManager().addComponent(chat);
    }
    
    public void initInven(){
             UIComponent inventory_full = new Inventory_full();
             inventory_full.setOnClickListener(this);
             Engine.getInstance().getUIManager().addComponent(inventory_full);
    }

    public Tile getTile(Map map, int x, int y) {
        if(map == null) return nullTile;
        return map.getTile(x, y);
    }

    @Override
    public void runSceneLoop() {
        this.bg.draw();
        if(MapModel.getInstance().getMyObject() == null) return;

        MapModel.getInstance().updateMapDisplayPosition();

        Map mainMap = MapModel.getInstance().getMap(MapModel.getInstance().getMyObject().getMapId());

        if(mainMap != null) {
          for(int y=0; y<20; y++) {
            for(int x=0; x<20; x++) {
                if(mainMap.getTile(x,y).getResId() == 0) continue;

                int d_x = MapModel.getInstance().getDisplayX(-1) + (x*MapModel.getTileSize());
                int d_y = MapModel.getInstance().getDisplayY(-1) + (y*MapModel.getTileSize());
                if(d_x<-1*MapModel.getTileSize() || d_y<-1*MapModel.getTileSize() || d_x > 800 || d_y > 600) continue;
                Engine.getInstance().drawTile(d_x, d_y, mainMap.getTile(x,y));
            }
          }
        }

        for(int i=0; i<8; i++) {
            Map map = MapModel.getInstance().getMap(mainMap.aroundMapId[i]);
            if(map != null) {
                for(int y=0; y<20; y++) {
                    for(int x=0; x<20; x++) {
                        if(map.getTile(x, y).getResId() == 0) continue;
                        int d_x = MapModel.getInstance().getDisplayX(i) + (x*MapModel.getTileSize());
                        int d_y = MapModel.getInstance().getDisplayY(i) + (y*MapModel.getTileSize());
                        if(d_x<-1*MapModel.getTileSize() || d_y<-1*MapModel.getTileSize() || d_x > 800 || d_y > 600) continue;
                        Engine.getInstance().drawTile(d_x, d_y, map.getTile(x, y));
                    }
                }
            }
        }

        TilePosition tilePosition = MapModel.getInstance()
            .getAroundTilePosition(MapModel.getInstance().getMyObject(), MapModel.MapPosition.DOWN);
        Map downMap = MapModel.getInstance().getMap(tilePosition.mapId);
        if(downMap != null) {
            Tile downTile = downMap.getTile(tilePosition.x, tilePosition.y);
            if(downTile == null || downTile.getResId() == 0) {
                GameObject obj = MapModel.getInstance().getMyObject();
                obj.move(obj.getMapId(), obj.getX(), obj.getY(), obj.getMapId(), obj.getX(), obj.getY()+4);
            }
        }

        for(Object entry : MapModel.getInstance().getDropItems()) {
            DropItem item = (DropItem)((java.util.Map.Entry)entry).getValue();
            Map map = MapModel.getInstance().getMap(item.getMapId());
            if(map == null || !map.isDisplay(MapModel.getInstance().getMyObject())) continue;
            int d_x = MapModel.getInstance().getDisplayX(map.getDisplayPosition()) + (item.getX()*MapModel.getTileSize());
            int d_y = MapModel.getInstance().getDisplayY(map.getDisplayPosition()) + (item.getY()*MapModel.getTileSize());
            if(d_x<-1*MapModel.getTileSize() || d_y<-1*MapModel.getTileSize() || d_x > 800 || d_y > 600) continue;

            Engine.getInstance().drawDropItem(d_x, d_y, item);
        }
        
        for(Object entry : MapModel.getInstance().getGameObjects()) {
            GameObject obj = (GameObject)((java.util.Map.Entry)entry).getValue();
            Map map = MapModel.getInstance().getMap(obj.getMapId());
            if(map == null || !map.isDisplay(MapModel.getInstance().getMyObject())) continue;

            int d_x = MapModel.getInstance().getDisplayX(map.getDisplayPosition()) + obj.getX() * MapModel.getTileSize() / 4;
            int d_y = MapModel.getInstance().getDisplayY(map.getDisplayPosition()) + obj.getY() * MapModel.getTileSize() / 4;

            if(d_x<-1*MapModel.getTileSize() || d_y<-1*MapModel.getTileSize() || d_x > 800 || d_y > 600) continue;

            Engine.getInstance().drawGameObject(d_x, d_y, obj);
        }

        joyStick.draw();
    }

    @Override
    public void release() {
    }

    @Override
    public void receivedPacket(Packet packet) {
        if(packet instanceof SC_MapInfo) {
            MapModel.getInstance().setMapInfo(((SC_MapInfo)packet));
        }

        if(packet instanceof SC_ObjectInfo) {
            MapModel.getInstance().setObjectInfo((SC_ObjectInfo)packet);
        }

        if(packet instanceof MoveObject) {
            MapModel.getInstance().moveObject((MoveObject)packet);
        }

        if(packet instanceof Chat) {
            MapModel.getInstance().chat((Chat)packet);
        }

        if(packet instanceof BreakTile) {
            MapModel.getInstance().breakTile((BreakTile)packet);
        }

        if(packet instanceof SC_DropItem) {
            MapModel.getInstance().dropItem((SC_DropItem)packet);
        }
    }

    @Override
    public void onClick(UIComponent comp, int x, int y) {
        if(comp instanceof MenuBtnComponent){}
        if(comp instanceof Inventory){
            initInven();
        }
        if(comp instanceof Inventory_full){
            //클릭?
        }
    }

    private class KeyPressed extends UIComponent{
        private Tile breakTile;
        public KeyPressed() {
        }

        public void loop() {
            if(breakTile != null) {
               breakTile.breakTile();
            }
        }

        public boolean keyReleasedHook() {
            if(breakTile != null) {
                breakTile.setDrawHp(false);
            }
            breakTile = null;
            return false;
        }

        public boolean keyPressedHook(char key, int keyCode) {
            if(MapModel.getInstance().getMyObject() == null) return false;

            if(keyCode == CONTROL || keyCode == 17) {
                TilePosition tilePosition = MapModel.getInstance().getAroundTilePosition(
                    MapModel.getInstance().getMyObject(), MapModel.MapPosition.DOWN);
                Map map = MapModel.getInstance().getMap(tilePosition.mapId);
                breakTile = map.getTile(tilePosition.x, tilePosition.y);
                breakTile.setDrawHp(true);
                return true;
            }

            //좌우 이동
            boolean isMove = false;
            int mapId = MapModel.getInstance().getMyObject().getMapId();
            int x = MapModel.getInstance().getMyObject().getX();
            int y = MapModel.getInstance().getMyObject().getY();
            int destMapId = MapModel.getInstance().getMyObject().getDestMapId();
            int destX = MapModel.getInstance().getMyObject().getDestX();
            int destY = MapModel.getInstance().getMyObject().getDestY();

            if(keyCode==LEFT || keyCode == 37){
                isMove = true;
                destX -= 2;
            }

            if(keyCode==RIGHT || keyCode == 39){
                isMove = true;
                destX += 2;
            }

            if(isMove) {
                TilePosition tilePosition = MapModel.getInstance().getAroundTilePosition(MapModel.getInstance().getMyObject(),
                    (keyCode==LEFT || keyCode == 37) ? MapModel.MapPosition.LEFT
                    : (keyCode==RIGHT || keyCode == 39) ? MapModel.MapPosition.RIGHT
                    : 0);
                Map map = MapModel.getInstance().getMap(tilePosition.mapId);
                if(map == null) {
                    Engine.getInstance().showNotify("비바람이 휘몰아 치고 있습니다", 120);
                    return true;
                }
                Tile tile = map.getTile(tilePosition.x, tilePosition.y);
                if(tile != null && tile.getResId() != 0) {
                    MapModel.getInstance().getMyObject().setDir((keyCode==LEFT || keyCode == 37) ? 0 : 1);
                    return true;
                }
            }

            if(destX<0 || destX>=80) {
                destMapId = MapModel.getInstance().getMap(MapModel.getInstance().getMyObject().getMapId())
                    .getAroundMapId(destX<0 ? MapModel.MapPosition.LEFT : MapModel.MapPosition.RIGHT);
                if(destMapId == -1) {
                    Engine.getInstance().showNotify("비바람이 휘몰아 치고 있습니다", 120);
                    return false;
                }
                mapId = destMapId;
                x = destX<0 ? 79 : 0;
                destX = destX<0 ? 78 : 1;
            }

            /*
            if(keyCode==UP || keyCode == 38)
            if(keyCode==DOWN || keyCode == 40)
            */

            if(!isMove) return false;

            print(x + ", " + y + "\n");

            MapModel.getInstance().getMyObject().move(mapId, x, y, destMapId, destX, destY);
            Engine.getInstance().getNetwork().write(
                new MoveObject(0, mapId, x, y, destMapId, destX, destY));

            return true;
        }

    }

    public class ChatBox extends UIEditBox {
        public void keyPressed(char key, int keyCode) {
            if(keyCode == ENTER) {
                if(this.getText().equals("")) {
                    Engine.getInstance().getUIManager().setFocusComponent(null);
                    return;
                }

                if(Engine.getInstance().getUIManager().getFocusComponent() == this) {
                    String text = this.getText();
                    Engine.getInstance().getNetwork().write(new Chat(0, 0, text));
                    this.setText("");
                    MapModel.getInstance().getMyObject().setHeadMessage(MapModel.getInstance().getMyObject().getName() + " : " + text);


                }
                return;
            }

            super.keyPressed(key, keyCode);
        }

        public boolean keyPressedHook(char key, int keyCode) {
            if(keyCode == ENTER) {
                if(Engine.getInstance().getUIManager().getFocusComponent() != this) {
                    Engine.getInstance().getUIManager().setFocusComponent(this);
                    return true;
                }
            }
            return false;
        }
    }

    private class JoyStick {
        void draw() {
            ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().fill(255, 50);
            ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().strokeWeight(10);
            ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().ellipse(circleX, circleY, circleRad*2, circleRad*2);
        }

       int getDirection(){     
            //System.out.println(direction);
            return move.checkDirection(move.isInRange(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseX, ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseY));
        }
    }

    public class MoveCharacter {
        //measuring length between mouse and circlecenter
        boolean isInRange(int mX, int mY) {      
            float len = ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().sqrt(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().sq(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseX-circleX)+((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().sq(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseY-circleY));
            if(len < circleRad) {
                return true;
            }
            else { 
                return false;
            }
        }
        
        //devide circle into 9 parts
        int checkDirection(boolean checkRange){
            if(checkRange == true && ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mousePressed ==true){
                if(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseX > circleX+(circleRad/3*1) && (((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseY > circleY-(circleRad/3*1) || ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseY < circleY+(circleRad/3*1))) {
                    return 2;
                }
                else if(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseX < circleX-(circleRad/3*1) && (((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseY > circleY-(circleRad/3*1) || ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseY < circleY+(circleRad/3*1))) {
                   return 1;
                }
                else if(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseY < circleY-(circleRad/3*1) && (((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseX > circleX-(circleRad/3*1) || ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().mouseX < circleX+(circleRad/3*1))) {
                    return 3;
                }
                else {
                    return 0;
                }
            }
            else {
                return 0;
            }
        }
    }
}

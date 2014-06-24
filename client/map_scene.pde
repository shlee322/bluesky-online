public static class MapScene implements Scene, UIOnClickListener {
    private MapModel model;
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

    private byte[] nullTiles = new byte[400];

    public MapScene(SC_MoveMap moveMap) {
        this.bg = Engine.getInstance().loadImage("images/sky.png");
        this.bg.setWidth(Engine.getInstance().getWidth());
        this.bg.setHeight(Engine.getInstance().getHeight());

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
        UIComponent menuBtnComponent = new MenuBtnComponent();
        UIComponent key = new KeyPressed(this.model);
        //loginBtnComp.setOnClickListener(this);
        menuBtnComponent.setOnClickListener(this);
        Engine.getInstance().getUIManager().addComponent(menuBtnComponent);
        Engine.getInstance().getUIManager().addComponent(key);
        joyStick = new JoyStick();

        ChatBox chat = new ChatBox(this.model);
        chat.emptyText = "메시지를 입력하려면 이곳을 클릭하세요.";
        chat.x = 0;
        chat.y = 550;
        chat.width = 800;
        chat.yy = 30;
        Engine.getInstance().getUIManager().addComponent(chat);
    }
    
    public byte[] getTiles(Map map) {
        if(map == null) return nullTiles;
        return map.getTiles();
    }
    @Override
    public void runSceneLoop() {
        this.bg.draw();
        if(this.model.getMyObject() == null) return;

        this.model.updateMapDisplayPosition();

        Map mainMap = this.model.getMap(this.model.getMyObject().getMapId());

        if(mainMap != null) {
          for(int y=0; y<20; y++) {
            for(int x=0; x<20; x++) {
                if(mainMap.getTiles()[y*20+x] == 0) continue;

                int d_x = this.model.getDisplayX(-1) + (x*MapModel.getTileSize());
                int d_y = this.model.getDisplayY(-1) + (y*MapModel.getTileSize());
                if(d_x<-1*MapModel.getTileSize() || d_y<-1*MapModel.getTileSize() || d_x > 800 || d_y > 600) continue;
                Engine.getInstance().drawTile(d_x, d_y, mainMap.getTiles()[y*20+x]);
            }
          }
        }

        for(int i=0; i<8; i++) {
            Map map = this.model.getMap(mainMap.aroundMapId[i]);
            if(map != null) {
                for(int y=0; y<20; y++) {
                    for(int x=0; x<20; x++) {
                        if(map.getTiles()[y*20+x] == 0) continue;
                        int d_x = this.model.getDisplayX(i) + (x*MapModel.getTileSize());
                        int d_y = this.model.getDisplayY(i) + (y*MapModel.getTileSize());
                        if(d_x<-1*MapModel.getTileSize() || d_y<-1*MapModel.getTileSize() || d_x > 800 || d_y > 600) continue;
                        Engine.getInstance().drawTile(d_x, d_y, map.getTiles()[y*20+x]);
                    }
                }
            }
        }

        for(Object entry : this.model.getGameObjects()) {
            GameObject obj = (GameObject)((java.util.Map.Entry)entry).getValue();
            Map map = this.model.getMap(obj.getMapId());
            if(!map.isDisplay(this.model.getMyObject())) continue;

            int d_x = this.model.getDisplayX(map.getDisplayPosition()) + obj.getX() * MapModel.getTileSize() / 4;
            int d_y = this.model.getDisplayY(map.getDisplayPosition()) + obj.getY() * MapModel.getTileSize() / 4;

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
            this.model.setMapInfo(((SC_MapInfo)packet));
        }

        if(packet instanceof SC_ObjectInfo) {
            this.model.setObjectInfo((SC_ObjectInfo)packet);
        }

        if(packet instanceof MoveObject) {
            this.model.moveObject((MoveObject)packet);
        }

        if(packet instanceof Chat) {
            this.model.chat((Chat)packet);
        }
    }

    @Override
    public void onClick(UIComponent comp, int x, int y) {
        MoveObject mo = new MoveObject();
    }

    private class MenuBtnComponent extends UIComponent {
        public void loop() {
            Engine.getInstance().getEngineAdapter().drawStroke(0, 0, 0, 255, 2);
            Engine.getInstance().getEngineAdapter().drawBox(700, 20, 16, 50, PI/2, 66, 139, 202, 255);
            Engine.getInstance().getEngineAdapter().drawBox(720, 20, 16, 50, PI/2, 66, 139, 202, 255);
            Engine.getInstance().getEngineAdapter().drawBox(740, 20, 16, 50, PI/2, 66, 139, 202, 255);
            Engine.getInstance().getEngineAdapter().drawBox(760, 20, 16, 50, PI/2, 66, 139, 202, 255);
        }
        public boolean clickScreen(int x, int y) {
            if(x>=700 && x<780 && y>=20 && y<70) {
                this.callClick(x, y);
                return true;
            }
            return false;
        }
    }

    private class KeyPressed extends UIComponent{
        private MapModel model;
        public KeyPressed(MapModel model) {
            this.model = model;
        }

        public boolean keyPressedHook(char key, int keyCode) {
            if(this.model.getMyObject() == null) return false; 
            if(keyCode==RIGHT || keyCode == 39){
                int nextMap=this.model.getMyObject().getMapId();
                if(this.model.getMyObject().getX()>389){
                      nextMap =  this.model.getMap(this.model.getMyObject().getMapId()).getAroundMapId(3);
                }
                this.model.getMyObject().move(
                    this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX()+10, this.model.getMyObject().getY());
                Engine.getInstance().getNetwork().write(new MoveObject(0, this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX()+10, this.model.getMyObject().getY()));
                return true;
            }
            if(keyCode==LEFT || keyCode == 37){
                int nextMap=this.model.getMyObject().getMapId();
                if(this.model.getMyObject().getX()<11){
                      nextMap =  this.model.getMap(this.model.getMyObject().getMapId()).getAroundMapId(6);
                }
                this.model.getMyObject().move(
                    this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX()-10, this.model.getMyObject().getY());
                Engine.getInstance().getNetwork().write(new MoveObject(0, this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX()+10, this.model.getMyObject().getY()));
                return true;
            } 
            if(keyCode==UP || keyCode == 38){
                int nextMap=this.model.getMyObject().getMapId();
                if(this.model.getMyObject().getY()>11){
                      nextMap =  this.model.getMap(this.model.getMyObject().getMapId()).getAroundMapId(0);
                }
                this.model.getMyObject().move(
                    this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX(), this.model.getMyObject().getY()-10);
                Engine.getInstance().getNetwork().write(new MoveObject(0, this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX()+10, this.model.getMyObject().getY()));
                return true;
            } 
            if(keyCode==DOWN || keyCode == 40){
                int nextMap=this.model.getMyObject().getMapId();
                if(this.model.getMyObject().getY()>389){
                      nextMap =  this.model.getMap(this.model.getMyObject().getMapId()).getAroundMapId(4);
                }
                this.model.getMyObject().move(
                    this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX(), this.model.getMyObject().getY()+10);
                Engine.getInstance().getNetwork().write(new MoveObject(0, this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    nextMap, this.model.getMyObject().getX()+10, this.model.getMyObject().getY()));
                return true;
            }
            return false;
        }

    }

    public class ChatBox extends UIEditBox {
        private MapModel model;

        public ChatBox(MapModel model) {
            this.model = model;
        }

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
                    this.model.getMyObject().setHeadMessage(this.model.getMyObject().getName() + " : " + text);


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

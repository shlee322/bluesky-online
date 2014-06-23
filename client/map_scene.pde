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

        int RealX = this.model.getMyObject().getX();
        int RealY = this.model.getMyObject().getY();

        int tileSize = Engine.getInstance().getWidth() / 24;

        int[][] MapAroundTile = new int[60][60];

        Map center = this.model.getMap(this.model.getMyObject().getMapId());

        byte[] mMap = new byte [400];

        mMap = getTiles(this.model.getMap(center.getAroundMapId(7)));
        int test = 0;

         for(int x=0;x<20;x++){
            for(int y=0;y<20;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0;
        mMap = getTiles(this.model.getMap(center.getAroundMapId(6)));
          for(int x=0;x<20;x++){
            for(int y=20;y<40;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0; 
        mMap = getTiles(this.model.getMap(center.getAroundMapId(5))); 
        for(int x=0;x<20;x++){
            for(int y=40;y<60;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0;  
        mMap = getTiles(this.model.getMap(center.getAroundMapId(0))); 
        for(int x=20;x<40;x++){
            for(int y=0;y<20;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0; 
                mMap = center.getTiles(); 
                for(int x=20;x<40;x++){
            for(int y=20;y<40;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0;  
        mMap = getTiles(this.model.getMap(center.getAroundMapId(4))); for(int x=20;x<40;x++){
            for(int y=40;y<60;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0;  
        mMap = getTiles(this.model.getMap(center.getAroundMapId(1))); for(int x=40;x<60;x++){
            for(int y=0;y<20;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0; 
        mMap = getTiles(this.model.getMap(center.getAroundMapId(2)));  for(int x=40;x<60;x++){
            for(int y=20;y<40;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0;  
        mMap = getTiles(this.model.getMap(center.getAroundMapId(3))); for(int x=40;x<60;x++){
            for(int y=40;y<60;y++){
                MapAroundTile[x][y]=mMap[test];
                test++;
            }
        }
        test = 0;

        int a = (RealX + 100)/20;
        int b = (RealY + 200)/20;

        for (int i = 0 ; i<24;i++){
            b=(RealY + 200)/20;
            for(int j = 0 ; j<32; j++){
                 Engine.getInstance().drawTile(i*tileSize, j*tileSize, MapAroundTile[a][b]);
                 b++;
            }a++;
        }
      //픽셀 좌표 x, y, 이미지 명

         //    1. 기준 맵 주변 8 개 맵까지 총 9개 모두 불러온다.
           //  2. (0,0) ~ (20*3,20*3)까지 좌표화 시킨다
           //  3. 그중에서 (x(-이동거리)+-400)/20, (y(-이동거리)+-300)/20 을 데려온다

         //   }
      //  }
        
        //가시성 있는 Tile 뿌림
        //Engine.getInstance().viewTile();

        //캐릭터 뿌림 (테스트로 자기만)
       // this.model.getMyObject().updateWeapon();
       Engine.getInstance().drawGameObject(400, 300, this.model.getMyObject());
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

        if(packet instanceof MoveObject) {
            this.model.moveObject((MoveObject)packet);
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
            print(keyCode + "\n");
            if(keyCode==RIGHT || keyCode == 39){
                this.model.getMyObject().move(
                    this.model.getMyObject().getMapId(), this.model.getMyObject().getX(), this.model.getMyObject().getY(),
                    this.model.getMyObject().getMapId(), this.model.getMyObject().getX()+10, this.model.getMyObject().getY());
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
                    //메시지 전송
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


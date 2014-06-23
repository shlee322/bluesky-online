public static class MapScene implements Scene, UIOnClickListener {
    private MapModel model;
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

        UIComponent menuBtnComponent = new MenuBtnComponent();
        //loginBtnComp.setOnClickListener(this);
        Engine.getInstance().getUIManager().addComponent(menuBtnComponent);
        joyStick = new JoyStick();
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
        this.model.getMyObject().updateWeapon();
        Engine.getInstance().drawGameObject(200, 200, this.model.getMyObject());
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
        //테스트 로그인
        Engine.getInstance().showNotify("로그인 시도중 입니다...", -1);
        Engine.getInstance().getNetwork().write(new CS_Login("test", "test"));
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


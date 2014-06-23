public static class LoginScene implements Scene, UIOnClickListener {
    private EImage bg;

    @Override
    public void init() {
        this.bg = Engine.getInstance().loadImage("images/intro.png");
        this.bg.setWidth(Engine.getInstance().getWidth());
        this.bg.setHeight(Engine.getInstance().getHeight());

        /*
        Engine.getInstance().getUIManager(); //을 통하여 UI Manager을 사용할 수 있음
        */
        UIComponent comp = new TestComponent();
        comp.setOnClickListener(this);
        Engine.getInstance().getUIManager().addComponent(comp);
    }

    @Override
    public void runSceneLoop() {
        this.bg.draw();
        Engine.getInstance().drawText("BlueSky Online", Engine.getInstance().getWidth() / 2, 150, 64, true);
        drawLoginBox();
        Engine.getInstance().fill(255, 255, 255, 255);
        

    }

    @Override
    public void release() {
    }

    @Override
    public void receivedPacket(Packet packet) {
    }

    @Override
    public void onClick(UIComponent comp, int x, int y) {
        //테스트 로그인
        Engine.getInstance().showNotify("로그인 시도중 입니다...", -1);
        Engine.getInstance().getNetwork().write(new CS_Login("test", "test"));
    }

    private class TestComponent extends UIComponent {
        public void loop() {
            //Engine.getInstance().drawText("테스트 로그인", 300, 500, 18, false);
        }

        public boolean clickScreen(int x, int y) {
            if(x>=200 && x<400 && y>=400 && y<600) {
                this.callClick(x, y);
                return true;
            }
            return false;
        }
    }

    static void drawLoginBox(){
        Engine.getInstance().getEngineAdapter().drawStroke(false);
        Engine.getInstance().getEngineAdapter().drawBox(220, 300, 360, 246, 30, 200, 200, 200, 100);   //loginBox

        Engine.getInstance().getEngineAdapter().drawStroke(66, 139, 202, 100, 2);
        Engine.getInstance().getEngineAdapter().drawBox(270, 350, 260, 90, 10, 255, 255, 255, 100);    //login

        Engine.getInstance().getEngineAdapter().drawStroke(66, 139, 202, 255, 1);
        Engine.getInstance().getEngineAdapter().line(270, 395, 530, 395);                           //login line

        Engine.getInstance().getEngineAdapter().drawStroke(255, 255, 255, 100, 1);
        Engine.getInstance().getEngineAdapter().drawBox(270, 460, 120, 46, 10, 66, 139, 202, 255);    //signIn

        Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
        Engine.getInstance().getEngineAdapter().drawText("Sign In", 300, 490, 23, false);
        Engine.getInstance().getEngineAdapter().drawBox(410, 460, 120, 46, 10, 66, 139, 202, 255);    //sighUp 
        Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
        Engine.getInstance().getEngineAdapter().drawText("Sign Up", 432, 490, 23, false);


    }
}
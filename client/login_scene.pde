public static class LoginScene implements Scene, UIOnClickListener {
    private EImage bg;
    private UIEditBox id;
    private UIEditBox pw;

    @Override
    public void init() {
        this.bg = Engine.getInstance().loadImage("images/intro.png");
        this.bg.setWidth(Engine.getInstance().getWidth());
        this.bg.setHeight(Engine.getInstance().getHeight());

        Engine.getInstance().getUIManager().clearComponentList();

        /*
        Engine.getInstance().getUIManager(); //을 통하여 UI Manager을 사용할 수 있음
        */

        id = new UIEditBox();
        id.x = 270;
        id.y = 350;
        id.yy = 30;
        Engine.getInstance().getUIManager().addComponent(id);

        pw = new UIEditBox();
        pw.x = 270;
        pw.y = 350 + 45;
        pw.yy = 30;
        pw.pw = true;
        Engine.getInstance().getUIManager().addComponent(pw);

        UIComponent comp = new TestComponent();
        comp.setOnClickListener(this);
        Engine.getInstance().getUIManager().addComponent(comp);

        UIComponent test = new UIEditBox();
        Engine.getInstance().getUIManager().addComponent(test);

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
        Engine.getInstance().showNotify("로그인 시도중 입니다...", -1);
        Engine.getInstance().getNetwork().write(new CS_Login(id.getText(), pw.getText()));
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
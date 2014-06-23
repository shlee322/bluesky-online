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
            Engine.getInstance().drawText("테스트 로그인", 300, 500, 18, false);
        }

        public boolean clickScreen(int x, int y) {
            if(x>=200 && x<400 && y>=400 && y<600) {
                this.callClick(x, y);
                return true;
            }
            return false;
        }
    }
}
public static class IntroScene implements Scene {
    private EImage bg;

    @Override
    public void init() {
        this.bg = Engine.getInstance().loadImage("images/intro.png");
        this.bg.setWidth(Engine.getInstance().getWidth());
        this.bg.setHeight(Engine.getInstance().getHeight());

        Engine.getInstance().playBGM("data/bgm/intro.mp3");

        Engine.getInstance().showNotify("서버에 접속중입니다...", -1);

        Engine.getInstance().getNetwork().initNetwork();
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
}
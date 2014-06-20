public static class LoginScene implements Scene {
    private EImage bg;

    @Override
    public void init() {
        this.bg = Engine.getInstance().getEngineAdapter().loadImage("images/intro.png");
    }

    @Override
    public void runSceneLoop() {
        this.bg.draw();

        Engine.getInstance().getEngineAdapter().drawText("BlueSky Online", Engine.getInstance().getWidth() / 2, 150, 64, true);
    }

    @Override
    public void release() {
    }
}
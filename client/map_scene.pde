public static class MapScene implements Scene {
    public MapScene(SC_MoveMap moveMap) {
        if(Engine.getInstance().getScene() instanceof LoginScene) {
            Engine.getInstance().getUIManager().clearComponentList();
        }

        Engine.getInstance().playBGM("data/bgm/map_1.mp3");
    }

    @Override
    public void init() {
    }

    @Override
    public void runSceneLoop() {
    }

    @Override
    public void release() {
    }
}
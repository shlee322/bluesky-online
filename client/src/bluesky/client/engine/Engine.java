package bluesky.client.engine;

import bluesky.client.ui.UIManager;

public class Engine {
    private static Engine engine = new Engine();

    private EngineAdapter engineAdapter;
    private Scene scene;
    private Scene lastScene;

    public static Engine getInstance() {
        return engine;
    }

    public void setEngineAdapter(EngineAdapter engineAdapter) {
        this.engineAdapter = engineAdapter;
    }

    public void init() {
    }

    public void runGameLoop() {
        if(this.scene != null) {
            if(lastScene != scene) {
                if(this.lastScene != null) {
                    this.lastScene.release();
                }

                this.lastScene = this.scene;
                this.scene.init();
            }

            this.scene.runSceneLoop();
        }

        UIManager.getInstance().runUILoop();
    }

    public void setScene(Scene scene) {
        this.scene = scene;
    }

    public Scene getScene() {
        return this.scene;
    }

    public void callTouch(int x, int y) {
    }

    public void callInputMethodTextChangedEvent(String committedText, String composedText) {
    }
}

package bluesky.client.login;

import bluesky.client.engine.Engine;
import bluesky.client.engine.Scene;
import bluesky.client.map.MapScene;

public class LoginScene implements Scene {
    @Override
    public void init() {
    }

    @Override
    public void runSceneLoop() {
        //테스트를 위하여 LoginScene가 실행되면 MapScene로 넘김
        Engine.getInstance().setScene(new MapScene());
    }

    @Override
    public void release() {
    }
}

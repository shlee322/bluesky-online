package bluesky.client.login;

import bluesky.client.engine.Model;
import bluesky.client.engine.Scene;

public class LoginModel implements Model {
    private static LoginModel instance;
    public static LoginModel getInstance() {
        if(instance == null) {
            instance = new LoginModel();
        }

        return instance;
    }

    @Override
    public void init(Scene scene) {

    }

    @Override
    public void release(Scene scene) {

    }
}

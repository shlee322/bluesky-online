package bluesky.client.map;

import bluesky.client.Client;
import bluesky.client.ui.UIButton;
import bluesky.client.ui.UIWindow;

public class MapWindow extends UIWindow {
    public MapWindow() {
        this.width = Client.getInstance().ScreenSizeWidth;
        this.height = Client.getInstance().ScreenSizeHeight;
        this.x = 0;
        this.y = 0;
        this.transparent = true;

        UIButton test = new UIButton();
        test.text = "Chat";
        test.x = 5;
        test.y = 5;

        this.addChild(test);
    }
}

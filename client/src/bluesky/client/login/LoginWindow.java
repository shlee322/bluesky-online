package bluesky.client.login;

import bluesky.client.Client;
import bluesky.client.map.MapScene;
import bluesky.client.ui.*;

public class LoginWindow extends UIWindow {
    public LoginWindow() {
        this.width = Client.getInstance().ScreenSizeWidth / 2;
        this.height = Client.getInstance().ScreenSizeHeight / 3;
        this.x = Client.getInstance().ScreenSizeWidth / 2 - this.width / 2;
        this.y = Client.getInstance().ScreenSizeHeight - Client.getInstance().ScreenSizeHeight / 5 - this.height;

        UIText idText = new UIText();
        idText.text = "ID";
        idText.x = 10;
        idText.y = 5;

        UIEditbox idEditbox = new UIEditbox();
        idEditbox.x = 40;
        idEditbox.y = 5;
        idEditbox.width = 100;

        UIText pwText = new UIText();
        pwText.text = "PW";
        pwText.x = 10;
        pwText.y = 45;

        UIEditbox pwEditbox = new UIEditbox();
        pwEditbox.x = 40;
        pwEditbox.y = 45;
        pwEditbox.width = 100;

        UIButton loginButton = new UIButton();
        loginButton.text = "Login";
        loginButton.x = 60;
        loginButton.y = 80;

        loginButton.setOnClickListener(new OnClickListener() {
            public void onClick() {
                UIManager.getInstance().clearWindow();
                Client.getInstance().changeScene(new MapScene());
            }
        });

        this.addChild(idText);
        this.addChild(idEditbox);
        this.addChild(pwText);
        this.addChild(pwEditbox);
        this.addChild(loginButton);
    }
}

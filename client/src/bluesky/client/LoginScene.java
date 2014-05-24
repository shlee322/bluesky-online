package bluesky.client;

import processing.core.PImage;

public class LoginScene extends Scene {
    private PImage bg;

    public void setup() {
        super.setup();

        this.bg = Client.getInstance().loadImage("bg/village.png");

        UIWindow window = new UIWindow();
        window.x = 300;
        window.y = 300;
        window.width = 200;
        window.height = 200;

        UIManager.getInstance().regWindow(window);

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

        window.addChild(idText);
        window.addChild(idEditbox);
        window.addChild(pwText);
        window.addChild(pwEditbox);
        window.addChild(loginButton);
    }

    public void draw() {
        Client.getInstance().image(this.bg, 0, 0, 800, 600);
    }
}

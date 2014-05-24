package bluesky.client.login;

import bluesky.client.Client;
import bluesky.client.Scene;
import bluesky.client.map.MapScene;
import bluesky.client.ui.*;
import processing.core.PImage;
import processing.core.PShape;

public class LoginScene extends Scene {
    private PImage bg;
    private PShape bgShape;

    public void setup() {
        super.setup();

        this.bg = Client.getInstance().loadImage("bg/village.png");
        this.bgShape = Client.getInstance().createShape();
        this.bgShape.beginShape();
        this.bgShape.texture(this.bg);
        this.bgShape.vertex(0, 0, 0, 0);
        this.bgShape.vertex(Client.getInstance().ScreenSizeWidth, 0, this.bg.width, 0);
        this.bgShape.vertex(Client.getInstance().ScreenSizeWidth, Client.getInstance().ScreenSizeHeight, this.bg.width, this.bg.height);
        this.bgShape.vertex(0, Client.getInstance().ScreenSizeHeight, 0, this.bg.height);
        this.bgShape.endShape();

        UIManager.getInstance().regWindow(new LoginWindow());
    }

    public void draw() {
        Client.getInstance().pushMatrix();
        Client.getInstance().translate(0, 0);
        Client.getInstance().shape(this.bgShape);
        Client.getInstance().popMatrix();
    }
}

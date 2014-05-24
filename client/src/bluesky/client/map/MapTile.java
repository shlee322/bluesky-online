package bluesky.client.map;

import bluesky.client.Client;
import processing.core.PImage;
import processing.core.PShape;

public class MapTile {
    private MapData md;
    private int x;
    private int y;

    private PImage img;
    private PShape shape;

    public MapTile(MapData md, int x, int y) {
        this.md = md;
        this.x = x;
        this.y = y;
        this.img = Client.getInstance().loadImage("tiles/1.png");
        shape = Client.getInstance().createShape();
        shape.beginShape();
        //testShape.beginShape();
        //testShape.textureWrap(REPEAT);
        shape.texture(img);
        shape.vertex(0, 0, 0, 0);
        shape.vertex(32, 0, 16, 0);
        shape.vertex(32, 32, 16, 16);
        shape.vertex(0, 32, 0, 16);
        shape.endShape();
    }

    public int getX() {
        return this.x;
    }

    public int getY() {
        return this.y;
    }

    public void draw() {
        Client.getInstance().pushMatrix();
        Client.getInstance().translate(this.md.getX() + (this.x * 32), this.md.getY() + (this.y * 32));
        Client.getInstance().shape(shape);
        Client.getInstance().popMatrix();

        //image(this.img, this.md.getX() + (this.x * 32), this.md.getY() + (this.y * 32));
    }
}
package bluesky.client;

import processing.core.PImage;

public class GameObject {
    private MapData map;
    protected int x;
    protected int y;
    protected int w;
    protected int h;
    protected int dir; //0 : left, 1:right

    protected int collisionLeft;
    protected int collisionRigth;

    protected int speed = 3;

    protected PImage[] img = new PImage[2];

    protected boolean isMoving;
    protected int movingFrame;
    protected int movingId;

    public GameObject(String path) {
        this.isMoving = false;

        this.changeImg(path);
    }

    public void setPosition(MapData map, int x, int y) {
        this.map = map;
        this.x = x;
        this.y = y;
        this.dir = 0;
        this.movingId = 0;
    }

    public int getX() {
        return this.x;
    }

    public int getY() {
        return this.y;
    }

    public void changeImg(String path) {
        this.img[0] = Client.getInstance().loadImage("characters/1.png");
        this.img[1] = getReversePImage(this.img[0]);

        this.w = this.img[0].width / 4;
        this.h = this.img[0].height / 2;

        this.collisionLeft = 20;
        this.collisionRigth = 20;

        this.x = 0;//400 - this.w / 2;
        this.y = 0;//300 - this.h / 2;
    }

    public MapData getMapData() {
        return this.map;
    }

    public void draw() {
        if (this.map == null) {
            return;
        }
        if (this.img == null) {
            return;
        }

        if (this.getMapData().getTile((this.x - 1) / 32, (this.y + this.speed) / 32) == null) {
            this.y += this.speed;
        }

        if (this.isMoving) {
            this.movingFrame += 1;
            if (this.movingFrame % 2 == 0) {
                int direction = this.dir;

                if (direction == 0 && this.getMapData().getTile((this.x - this.speed - this.collisionLeft - 1) / 32, (this.y - 1) / 32) == null) {
                    this.x -= this.speed;
                } else if (direction == 1 && this.getMapData().getTile((this.x + this.speed + this.collisionRigth - 1) / 32, (this.y - 1) / 32) == null) {
                    this.x += this.speed;
                }
            }

            if (this.movingFrame >= 10) {
                this.movingFrame = 0;

                this.movingId += 1;
                if (this.movingId % 4 == 0) {
                    this.isMoving = false;
                    this.movingId = 0;
                }
            }
        }

        PImage drawImg = this.img[this.dir % 2].get(this.movingId % 4 * this.w, (this.dir < 2 ? 0 : 1) * this.h, this.w, this.h);
        Client.getInstance().image(drawImg, this.map.getX() + this.x - (this.w / 2), this.map.getY() + this.y - this.h);
    }

    public void move(int direction) { //0, 1, 2, 3
        if (this.isMoving) {
            if (this.dir == direction) {
                return;
            }
        }

        this.isMoving = true;
        this.movingFrame = 0;
        this.dir = direction;
    }

    private PImage getReversePImage(PImage image) {
        PImage reverse = Client.getInstance().createImage(image.width, image.height, Client.getInstance().ARGB);
        for (int i = 0; i < image.width; i++) {
            for (int j = 0; j < image.height; j++) {
                reverse.set(image.width - 1 - i, j, image.get(i, j));
            }
        }
        return reverse;
    }
}

package bluesky.client.ui;

import processing.core.PFont;

public class UIWindow extends UIControl {
    private boolean titleLook;
    private int moveX = 0;
    private int moveY = 0;

    public void callDraw() {
        super.callDraw();

        this.uiRect(0, 0, this.width, 20);
    }

    protected void draw() {
        this.uiRect(0, 0, this.width, this.height);
    }

    protected int getParentY() {
        return super.getParentY() + 20; //title
    }

    public void uiRect(int x, int y, int w, int h) {
        super.uiRect(x, y - 20, w, h);
    }

    public void uiText(int x, int y, int w, int h, String text, PFont font, int size, int c) {
        super.uiText(x, y - 20, w, h, text, font, size, c);
    }

    public UIXYFocusControl getXYFocusControl(int x, int y) {
        return super.getXYFocusControl(x, y - 20);
    }

    public boolean callMousePressed(int x, int y) {
        if (y < 20) {
            this.titleLook = true;
            this.moveX = x;
            this.moveY = y;
            System.out.println("Window Title " + x + ", " + y);
        }

        System.out.println("Window Focus " + x + ", " + y);
        return true;
    }

    public boolean callMouseDragged(int x, int y) {
        System.out.println("callMouseDragged " + x + ", " + y);
        if (this.titleLook) {
            System.out.println("test - " + (x - this.moveX) + ", " + (y - this.moveY));
            this.x += (x - this.moveX);
            this.y += (y - this.moveY);

            this.moveX = x;
            this.moveY = y;

        }

        return false;
    }

    public boolean callMouseReleased(int x, int y) {
        this.titleLook = false;
        this.moveX = 0;
        this.moveY = 0;
        System.out.println("callMouseReleased " + x + ", " + y);
        return false;
    }
}

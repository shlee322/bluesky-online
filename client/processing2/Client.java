package bluesky.client.processing2;

import bluesky.client.login.LoginScene;
import bluesky.client.ui.UIManager;
import processing.core.*;

public class Client extends PApplet {
    private static Client instance;
    private Scene scene;
    public final int ScreenSizeWidth = 960;
    public final int ScreenSizeHeight = 640;

    public String committedText = "";
    public String composedText = "";
    private InputMethodSystem inputMethodSystem = new InputMethodSystem(this);

    public static void main(String args[]) {
        PApplet.main(new String[]{"--present", Client.class.getName()});
    }

    public static Client getInstance() {
        return instance;
    }

    public Client() {
        super();

        instance = this;

        sketchPath = "/data/projects/hobby/game/bluesky-online/client";

        /*displayWidth = ScreenSizeWidth;
        displayHeight = ScreenSizeHeight;       */
    }

    public String sketchRenderer() {
        return P3D;
    }

    public void setup() {
        size(ScreenSizeWidth, ScreenSizeHeight, P3D);
        noStroke();
        frameRate(60);

        scene = new LoginScene();
        scene.setup();
    }

    public void changeScene(Scene s) {
        scene = s;
        s.setup();
    }

    public void draw() {
        background(0);

        if (scene != null) {
            scene.draw();
        }

        UIManager.getInstance().draw();
    }

    public void keyPressed() {
        if (UIManager.getInstance().keyPressed(key, keyCode)) return;
        if (scene.keyPressed(key, keyCode)) return;
    }

    public void keyReleased() {
        if (UIManager.getInstance().keyReleased(key, keyCode)) return;
        if (scene.keyReleased(key, keyCode)) return;
    }

    public void mousePressed() {
        if (UIManager.getInstance().mousePressed(mouseX, mouseY)) return;
        if (scene.mousePressed(mouseX, mouseY)) return;
    }

    public void mouseDragged() {
        if (UIManager.getInstance().mouseDragged(mouseX, mouseY)) return;
        if (scene.mouseDragged(mouseX, mouseY)) return;
    }

    public void mouseReleased() {
        if (UIManager.getInstance().mouseReleased(mouseX, mouseY)) return;
        if (scene.mouseReleased(mouseX, mouseY)) return;
    }

    public void inputMethodTextChanged() {
        if (UIManager.getInstance().inputMethodTextChanged(committedText, composedText)) return;
        if (scene.inputMethodTextChanged(committedText, composedText)) return;
    }

    public void addListeners(java.awt.Component comp) {
        super.addListeners(comp);
        comp.enableInputMethods(true);
        comp.addInputMethodListener(inputMethodSystem);
    }

    public void removeListeners(java.awt.Component comp) {
        super.removeListeners(comp);
        comp.enableInputMethods(false);
        comp.removeInputMethodListener(inputMethodSystem);
    }

    public java.awt.im.InputMethodRequests getInputMethodRequests() {
        return inputMethodSystem;
    }
}
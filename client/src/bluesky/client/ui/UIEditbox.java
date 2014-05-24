package bluesky.client.ui;

import bluesky.client.Client;
import processing.core.PFont;

public class UIEditbox extends UIControl {
    public PFont textFont;
    public int textColor;
    public String text;
    public int textFrame;
    public String composedText;

    public UIEditbox() {
        this.textFont = Client.getInstance().createFont("Arial", 16, true);
        this.textColor = 0;
        this.text = "";
        this.composedText = "";
        this.width = 60;
        this.height = 30;
    }

    protected void draw() {
        String cursor = "";

        if (this.isFocus()) {
            textFrame += 1;

            if (textFrame < 15) {
                cursor = "|";
            } else if (textFrame > 30) {
                textFrame = 0;
            }
        }

        //TODO: text focus
        this.uiRect(0, 0, this.width, this.height, 255);
        this.uiText(0, 0, this.width, this.height, this.text + this.composedText + cursor, this.textFont, 16, this.textColor);
    }

    public boolean callKeyPressed(int key, int code) {
        if (Client.getInstance().keyCode == Client.getInstance().BACKSPACE) {
            if (this.text.length() < 1) {
                return true;
            }

            this.text = this.text.substring(0, this.text.length() - 1);
            return true;
        }

        this.text += String.valueOf(Character.toChars(key));
        return true;
    }

    public boolean callKeyReleased(int key, int code) {
        return true;
    }

    public boolean callMousePressed(int x, int y) {
        return true;
    }

    public boolean callMouseReleased(int x, int y) {
        return true;
    }

    public boolean callInputMethodTextChanged(String committedText, String composedText) {
        if (committedText.length() > 0) {
            this.text += committedText;
            this.composedText = "";
        } else {
            this.composedText = composedText;
        }
        return true;
    }
}

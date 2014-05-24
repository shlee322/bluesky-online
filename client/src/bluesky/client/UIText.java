package bluesky.client;

import processing.core.PFont;

public class UIText extends UIControl
{
  public PFont textFont;
  public int textColor;
  public String text;
  
  public UIText() {
    this.textFont = Client.getInstance().createFont("Arial",16,true);
    this.textColor = 0;
    this.text = "";
  }
  
  protected void draw() {
    this.uiText(0, 0, this.width, this.height, this.text, this.textFont, 16, this.textColor);

  }
}

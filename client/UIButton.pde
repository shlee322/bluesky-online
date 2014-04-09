public class UIButton extends UIControl
{
  public PFont textFont;
  public int textColor;
  public String text;
  private boolean click;
  
  public UIButton() {
    this.textFont = createFont("Arial",16,true);
    this.textColor = 0;
    this.text = "";
    this.width = 60;
    this.height = 30;
  }
  
  protected void draw() {
    this.uiRect(0, 0, this.width, this.height, this.click ? 0 : 255);
    this.uiText(0, 0, this.width, this.height, this.text, this.textFont, 16, this.textColor);
  }
  
  public boolean callMousePressed(int x, int y) {
    this.click = true;
    return true;
  }
  
  public boolean callMouseReleased(int x, int y) {
    this.click = false;
    return true;
  }
}

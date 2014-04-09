public class UIEditbox extends UIControl
{
  public PFont textFont;
  public int textColor;
  public String text;
  public int textFrame;

  public UIEditbox() {
    this.textFont = createFont("Arial",16,true);
    this.textColor = 0;
    this.text = "";
    this.width = 60;
    this.height = 30;
  }
  
  protected void draw() {
    String cursor = "";
    
    if(this.isFocus()) {
      textFrame += 1;
      
      if(textFrame < 15) {
        cursor = "|";
      } else if(textFrame > 30){
        textFrame = 0;
      }
    }
    
    //TODO: text focus
    this.uiRect(0, 0, this.width, this.height, 255);
    this.uiText(0, 0, this.width, this.height, this.text + cursor, this.textFont, 16, this.textColor);
  }
  
  public boolean callKeyPressed(int key, int code) {
    if(keyCode == BACKSPACE) {
      if(this.text.length() < 1) {
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
}

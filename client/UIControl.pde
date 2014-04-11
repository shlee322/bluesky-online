public class UIControl
{
  private UIControl parent;
  private ArrayList<UIControl> children;
  
  public int x;
  public int y;
  public int width;
  public int height;
  
  public UIControl() {
    this.parent = null;
    this.children = new ArrayList<UIControl>();
    
    this.x = 0;
    this.y = 0;
    this.width = 200;
    this.height = 200;
  }
  
  protected void draw() {
  }
  
  public void callDraw() {
    this.draw();
    for(UIControl control : this.children) {
      control.callDraw();
    }
  }
  
  private void setParent(UIControl parent) {
    this.parent = parent;
  }
  
  public void addChild(UIControl child) {
    this.children.add(child);
    child.setParent(this);
  }
  
  protected int getParentX() {
    return parent != null ? parent.getParentX() + this.x : this.x;
  }
  
  protected int getParentY() {
    return parent != null ? parent.getParentY() + this.y : this.y;
  }
  
  public void uiRect(int x, int y, int w, int h) {
    this.uiRect(x,y,w,h,255);
  }
  
  public void uiRect(int x, int y, int w, int h, int c) {
    fill(c);
    rect(this.getParentX() + x, this.getParentY() + y, w, h);
  }
  
  public void uiText(int x, int y, int w, int h, String text, PFont font, int size, int c) {
    textFont(font, 16);
    fill(c);
    text(text, this.getParentX()+x, this.getParentY()+y, w, h);
  }
  
  public UIXYFocusControl getXYFocusControl(int x, int y) {
    for(int i=(this.children.size() - 1); i>=0; i--) {
      UIControl child = this.children.get(i);
      if(x>=child.x && y>=child.y && x<=(child.x+child.width) && y<=(child.y+child.height)) {
        UIXYFocusControl focusControl = child.getXYFocusControl(x-child.x, y-child.y);
        focusControl.addXY(x, y);
        return focusControl;
      }
    }
    
    return new UIXYFocusControl(this, x, y);
  }
  
  public boolean isFocus() {
    return UIManager.getInstance().getFocusControl() == this;
  }
  
  public boolean callKeyPressed(int key, int code) {
    return true;
  }

  public boolean callKeyReleased(int key, int code) {
    return true;
  }
  
  public boolean callMousePressed(int x, int y) {
    return false;
  }
  
  public boolean callMouseDragged(int x, int y) {
    return false;
  }
  
  public boolean callMouseReleased(int x, int y) {
    return false;
  }
  
  public boolean callInputMethodTextChanged(String committedText, String composedText) {
    return false;
  }
}

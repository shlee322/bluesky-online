public class UIXYFocusControl
{
  private UIControl focusControl;
  private int x;
  private int y;
  
  public UIXYFocusControl(UIControl control, int x, int y) {
    this.focusControl = control;
    this.x = x;
    this.y = y;
  }
  
  public void addXY(int x, int y) {
    this.x += x;
    this.y += y;
  }
  
  public UIControl getFocusControl() {
    return this.focusControl;
  }
  
  public int getX() {
    return this.x;
  }
  
  public int getY() {
    return this.y;
  }
}

package bluesky.client;

import java.util.ArrayList;

public class UIManager
{
  private static UIManager instance = new UIManager();
  
  private ArrayList<UIWindow> windows = new ArrayList<UIWindow>();
  private UIXYFocusControl focusControl;
  
  public static UIManager getInstance() {
    return instance;
  }
  
  public UIWindow regWindow(UIWindow window) {
    this.windows.add(window);
    return window;
  }
  
  public void clearWindow() {
    this.windows.clear();
    this.focusControl = null;
  }
  
  protected void draw() {
    for(UIWindow window : this.windows) {
      window.callDraw();
    }
  }
  
  private UIXYFocusControl getXYFocusControl(int x, int y) {
    for(int i=(this.windows.size() - 1); i>=0; i--) {
      UIWindow window = this.windows.get(i);
      if(x>=window.x && y>=window.y && x<=(window.x+window.width) && y<=(window.y+window.height)) {
        return window.getXYFocusControl(x-window.x, y-window.y);
      }
    }
    
    return null;
  }
  
  public UIControl getFocusControl() {
    return this.focusControl != null ? this.focusControl.getFocusControl() : null;
  }
  
  public boolean keyPressed(int key, int code) {
    if(this.focusControl == null) return false;
    this.focusControl.getFocusControl().callKeyPressed(key, code);
    return true;
  }

  public boolean keyReleased(int key, int code) {
    if(this.focusControl == null) return false;
    this.focusControl.getFocusControl().callKeyReleased(key, code);
    return true;
  }
  
  public boolean mousePressed(int x, int y) {
    UIXYFocusControl control = this.getXYFocusControl(x, y);
    if(control==null) {
      this.focusControl = null;
      return false;
    }
    this.focusControl = control;
    control.getFocusControl().callMousePressed(control.getX(), control.getY());
    return true;
  }
  
  public boolean mouseDragged(int x, int y) {
    if(this.focusControl == null) return false;
    
    this.focusControl.getFocusControl().callMouseDragged(x - this.focusControl.getX(), y - this.focusControl.getY());
    
    return true;
  }
  
  public boolean mouseReleased(int x, int y) {
    if(this.focusControl == null) return false;
    this.focusControl.getFocusControl().callMouseReleased(x - this.focusControl.getX(), y - this.focusControl.getY());
    return true;
  }
    
  public boolean inputMethodTextChanged(String committedText, String composedText) {
    if(this.focusControl == null) return false;
    this.focusControl.getFocusControl().callInputMethodTextChanged(committedText, composedText);
    return true;
  }
}

class Scene {
  private PImage bg;
  
  public void setup() {
    this.bg = loadImage("bg/village.png");
    print("Scene Setup\n");
  }
  
  public void draw() {
    image(this.bg, 0, 0, 800, 600);
  }
  
  public boolean keyPressed(int key, int code) {
    return false;
  }
  
  public boolean keyReleased(int key, int code) {
    return false;
  }
  
  public boolean mousePressed(int x, int y) {
    return false;
  }
  
  public boolean mouseDragged(int x, int y) {
    return false;
  }
  
  public boolean mouseReleased(int x, int y) {
    return false;
  }
  
  public boolean inputMethodTextChanged(String committedText, String composedText) {
    return false;
  }
}

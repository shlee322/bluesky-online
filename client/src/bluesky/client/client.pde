Scene scene;
final int ScreenSizeWidth = 960;
final int ScreenSizeHeight = 640;

void setup() {
  size(ScreenSizeWidth, ScreenSizeHeight, P3D);
  noStroke();
  frameRate(60);
  
  scene = new LoginScene();
  scene.setup();
}

void changeScene(Scene s) {
  scene = s;
  s.setup();
}

void draw() {
  background(0);  
  
  if(scene != null) {
    scene.draw();
  }
  
  UIManager.getInstance().draw();
}

void keyPressed() {
  if(UIManager.getInstance().keyPressed(key, keyCode)) return;
  if(scene.keyPressed(key, keyCode)) return;
}

void keyReleased() {
  if(UIManager.getInstance().keyReleased(key, keyCode)) return;
  if(scene.keyReleased(key, keyCode)) return;
}

void mousePressed() {
  if(UIManager.getInstance().mousePressed(mouseX, mouseY)) return;
  if(scene.mousePressed(mouseX, mouseY)) return;
}

void mouseDragged() {
  if(UIManager.getInstance().mouseDragged(mouseX, mouseY)) return;
  if(scene.mouseDragged(mouseX, mouseY)) return;
}

void mouseReleased() {
  if(UIManager.getInstance().mouseReleased(mouseX, mouseY)) return;
  if(scene.mouseReleased(mouseX, mouseY)) return;
}

void inputMethodTextChanged() {
  if(UIManager.getInstance().inputMethodTextChanged(committedText, composedText)) return;
  if(scene.inputMethodTextChanged(committedText, composedText)) return;
}

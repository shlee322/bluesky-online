class MapScene extends Scene {
  private ArrayList<GameObject> objects; //not exist linkedlist......
  
  private UserObject userObject;
  
  public void setup() {
    super.setup();
    
    this.objects = new ArrayList<GameObject>();
    
    ////////////////??Test
    this.userObject = new UserObject();
    this.addObject(this.userObject);
    UIWindow window = new UIWindow();
    window.x = 30;
    window.y = 30;
    
    UIWindow testWindow = UIManager.getInstance().regWindow(window);
    
    UIText testText = new UIText();
    testText.text = "UI Text Test";
    testText.x = 5;
    testText.y = 5;
    
    UIButton testButton = new UIButton();
    testButton.text = "Button";
    testButton.x = 60;
    testButton.y = 60;
    
    UIEditbox testEditbox = new UIEditbox();
    testEditbox.x = 60;
    testEditbox.y = 110;
    
    testWindow.addChild(testText);
    testWindow.addChild(testButton);
    testWindow.addChild(testEditbox);
  }
  
  public void draw() {
    super.draw();
    
    for(GameObject obj : this.objects) {
      obj.draw();
    }
  }
  
  public void addObject(GameObject c) {
    this.objects.add(c);
  }
  
  public boolean keyPressed(int key, int code) {
    if(keyCode == LEFT) {
      userObject.move(1);
      return true;
    } else if(keyCode == UP) {
      userObject.move(3);
      return true;
    } else if(keyCode == RIGHT) {
      userObject.move(2);
      return true;
    } else if(keyCode == DOWN) {
      userObject.move(0);
      return true;
    }
    return false;
  }
}

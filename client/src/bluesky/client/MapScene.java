package bluesky.client;

public class MapScene extends Scene {
  public class MapPosition {
    public static final int CENTER = 0;
    public static final int LEFT = 1;
    public static final int UP = 2;
    public static final int RIGHT = 3;
    public static final int DOWN = 4;
    public static final int UP_LEFT = 5;
    public static final int UP_RIGHT = 6;
    public static final int DOWN_LEFT = 7;
    public static final int DOWN_RIGHT = 8;
  }
  
  private MapData[] mapData;  
  private UserObject userObject;
  
  public void setup() {
    super.setup();
    
    this.mapData = new MapData[9];
    //Loading Scene
    
    //Network MapLoad call
    
    this.userObject = new UserObject();
    loadMap();
    
    for(int i=0; i<9; i++) {
      System.out.println(i + " " + this.mapData[i].getX() + " " + this.mapData[i].getY());
    }
  }
  
  public void loadMap() {
    //test
    for(int i=0; i<9; i++) {
      this.mapData[i] = new MapData(this);
      this.mapData[i].setMapPosition(i);
    }
  
    for(int x=0; x<20; x++) {
      for(int y=12; y<20; y++) {
        this.mapData[MapPosition.CENTER].setTile(x, y, 0);
        this.mapData[MapPosition.LEFT].setTile(x, y, 0);
        this.mapData[MapPosition.RIGHT].setTile(x, y, 0);
      }
    }
    for(int x=0; x<20; x++) {
      for(int y=0; y<20; y++) {
        this.mapData[MapPosition.DOWN].setTile(x, y, 0);
        this.mapData[MapPosition.DOWN_LEFT].setTile(x, y, 0);
        this.mapData[MapPosition.DOWN_RIGHT].setTile(x, y, 0);
      }
    }
    
    this.mapData[MapPosition.CENTER].setTile(8, 11, 0);
    this.mapData[MapPosition.CENTER].addObject(this.userObject);
    
    this.userObject.setPosition(this.mapData[MapPosition.CENTER], 10*32, 12*32);
  }
  
  public int getCenterX() {
    return this.userObject.getX();
  }
  
  public int getCenterY() {
    return this.userObject.getY();
  }
  
  public void draw() {
    super.draw();

    Client.getInstance().fill(0, 0, 200);
      Client.getInstance().rect(0, 0, 800, 400);
    
    for(int i=0; i<9; i++) {
      this.mapData[i].drawTiles();
    }
    for(int i=0; i<9; i++) {
      this.mapData[i].drawObjects();
    }

      Client.getInstance().fill(255);
      Client.getInstance().text("Score : " + this.userObject.getScore(), 5, 15);
    
    //map move
    if(this.getCenterX()<0 || this.getCenterX() >= 32*20 || this.getCenterY()<0 || this.getCenterY() >= 32*20) {
        Client.getInstance().scene = new GameOverScene(this.userObject.getScore());
    }
  }
  
  public boolean keyPressed(int key, int code) {
    if(userObject == null)
      return false;
    
    if(Client.getInstance().keyCode == Client.getInstance().DOWN) {
      userObject.stateDownControl(true);
    }
    
    if(Client.getInstance().keyCode == Client.getInstance().CONTROL) {
      userObject.callControl();
    }
      
    if(Client.getInstance().keyCode == Client.getInstance().LEFT) {
      userObject.move(0);
      return true;
    } else if(Client.getInstance().keyCode == Client.getInstance().RIGHT) {
      userObject.move(1);
      return true;
    }
    
    return false;
  }
  
  public boolean keyReleased(int key, int code) {
    if(Client.getInstance().keyCode == Client.getInstance().DOWN) {
      userObject.stateDownControl(false);
      return true;
    }
    return false;
  }
}

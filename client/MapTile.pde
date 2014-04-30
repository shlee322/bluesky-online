class MapTile {
  private MapData md;
  private int x;
  private int y;
  
  private PImage img;
  
  public MapTile(MapData md, int x, int y) {
    this.md = md;
    this.x = x;
    this.y = y;
    this.img = loadImage("tiles/1.png");
  }
  
  public int getX() {
    return this.x;
  }
  
  public int getY() {
    return this.y;
  }
  
  public void draw() {
    image(this.img, this.md.getX() + (this.x * 32), this.md.getY() + (this.y * 32));
  }
}

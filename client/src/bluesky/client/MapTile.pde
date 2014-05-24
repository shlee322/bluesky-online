class MapTile {
  private MapData md;
  private int x;
  private int y;
  
  private PImage img;
  private PShape shape;
  
  public MapTile(MapData md, int x, int y) {
    this.md = md;
    this.x = x;
    this.y = y;
    this.img = loadImage("tiles/1.png");
    shape = createShape();
    shape.beginShape();
    //testShape.beginShape();
    //testShape.textureWrap(REPEAT);
    shape.texture(img);
    shape.vertex(0, 0, 0, 0);
    shape.vertex(32, 0, 16, 0);
    shape.vertex(32, 32, 16, 16);
    shape.vertex(0, 32, 0, 16);
    shape.endShape();
  }
  
  public int getX() {
    return this.x;
  }
  
  public int getY() {
    return this.y;
  }
  
  public void draw() {
    pushMatrix();
    translate(this.md.getX() + (this.x * 32), this.md.getY() + (this.y * 32));
    shape(shape);
    popMatrix();

    //image(this.img, this.md.getX() + (this.x * 32), this.md.getY() + (this.y * 32));
  }
}
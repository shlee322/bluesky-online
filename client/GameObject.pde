class GameObject {
  private int x;
  private int y;
  private int w;
  private int h;
  private int dir;
  
  private PImage img;
  
  private boolean isMoving;
  private int movingFrame;  
  
  public GameObject(String path) {
    this.isMoving = false;
    
    this.changeImg(path);
  }
  
  public void changeImg(String path) {
    this.img = loadImage("chr/ogre.png");
    
    this.w = this.img.width / 4;
    this.h = this.img.height / 4;
    
    this.x = 400 - this.w / 2;
    this.y = 300 - this.h / 2;
  }
  
  public void draw() {
    if(this.img == null) {
      return;
    }
    
    if(this.isMoving) {
      this.movingFrame += 1;
      if(this.movingFrame%2 == 0) {
        int direction = this.dir / 4;
        if(direction == 0) {
          this.y += 1;
        } else if(direction == 1) {
          this.x -= 1;
        } else if(direction == 2) {
          this.x += 1;
        } else if(direction == 3) {
          this.y -= 1;
        }
      }
      
      if(this.movingFrame >= 10) {
        this.movingFrame = 0;
        
        this.dir += 1;
        if(this.dir%4 == 0) {
          this.isMoving = false;
          this.dir = this.dir - 4;
        }
      }
    }
    
    PImage darwImg = this.img.get(this.dir%4 * this.w, this.dir/4 * this.h, this.w, this.h);
    image(darwImg, this.x, this.y);
  }
  
  public void move(int direction) { //0, 1, 2, 3
    if(this.isMoving) {
      if(this.dir / 4 == direction) {
        return;
      }
    }
    
    this.isMoving = true;
    this.movingFrame = 0;
    this.dir = direction * 4;
  }
}

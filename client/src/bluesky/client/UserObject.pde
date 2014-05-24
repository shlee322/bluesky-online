class UserObject extends GameObject {
  private boolean down;
  private int score;
  
  public UserObject() {
    super("./img/chr/ogre.png");
  }
  
  public void draw() {
    super.draw();
  }
  
  public void callControl() {
    int tileX = (this.x-1)/32;
    int tileY = (this.y-1)/32;
    
    MapTile tile = this.getMapData().getTile(tileX + (this.dir%2 == 0 ? -1 : 1), tileY);
    if(tile != null && !down) {
      this.getMapData().setTile(tile.getX(), tile.getY(), -1);
      score += 1;
    } else {
      tile = this.getMapData().getTile(tileX, tileY+1);
      if(tile != null) {
        this.getMapData().setTile(tile.getX(), tile.getY(), -1);
        score += 1;
      }
    }
  }
  
  public void stateDownControl(boolean b) {
    down = b;
  }
  
  public int getScore() {
    return score;
  }
}

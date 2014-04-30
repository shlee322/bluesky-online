class GameOverScene extends Scene {
  private int score;
  private int best;
  
  public GameOverScene(int score) {
    this.score = score;
    String[] lines = loadStrings("score.dat");
    if(lines.length>0) {
      best = int(lines[0]);
    }
    if(best<score) {
      saveStrings("score.dat", new String[]{String.valueOf(score)});
    }
  }
  
  public void setup() {
    super.setup();
  }
  
  public void draw() {
    super.draw();
    
    fill(255);
    text("Score : " + this.score, 300, 200);
    text("Best : " + this.best, 300, 220);
  }
}

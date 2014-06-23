import ddf.minim.*;

class ProcessingEngineAdapter implements EngineAdapter {
	private PFont[] fonts = new PFont[4];
	private int[] fontSize = new int[]{18, 24, 48, 64};
	private PApplet processing;
	private Minim minim;
	private AudioPlayer bgmPlayer;

	public ProcessingEngineAdapter(PApplet processing) {
		this.processing = processing;

		this.getProcessing().frameRate(60);
		this.getProcessing().size(800, 600, P3D);

		for(int i=0; i<4; i++) {
			this.fonts[i] = this.getProcessing().createFont("NanumGothic", this.fontSize[i]);
		}

		this.minim = new Minim(this.getProcessing());
	}

	public void runGameLoop() {
		if(bgmPlayer != null && !bgmPlayer.isPlaying()) {
			bgmPlayer.rewind();
			bgmPlayer.play();
		}

		this.drawText("FPS : " + getFrameRate(), 10, 30);
	}

	public int getWidth() {
		return 800;
	}

	public int getHeight() {
		return 600;
	}

	public int getFrameRate() {
		return round(getProcessing().frameRate);
	}

	public PApplet getProcessing() {
		return this.processing;
	}

	public void playBGM(String path) {
		if(bgmPlayer != null) {
			bgmPlayer.close();
		}

		bgmPlayer = minim.loadFile(path);
		bgmPlayer.play();
	}

	public void drawText(String text, int x, int y) {
		this.drawText(text, x, y, 18);
	}

	public void drawText(String text, int x, int y, int size) {
		this.drawText(text, x, y, size, false);
	}

	public void drawText(String text, int x, int y, int size, boolean center) {
		if(center) {
			this.getProcessing().textAlign(CENTER, CENTER);
		} else {
			this.getProcessing().textAlign(LEFT);
		}
		
		for(int i=0; i<fontSize.length; i++) {
			if(fontSize[i] != size) continue;
			this.getProcessing().textFont(fonts[i], size);
		}
		this.getProcessing().textSize(size);
		this.getProcessing().text(text, x, y);
	}

	public void drawNotify(String text) {
		if(text == null || text.equals("")) return;

		this.getProcessing().fill(0, 0, 0, 160);
		rect(0, getHeight() / 2 - 25, this.getWidth(), 50);
		this.getProcessing().fill(255);
		this.drawText(text, getWidth() / 2, getHeight() / 2, 18, true);
	}

	
	public void fill(float r, float g, float b, float alpha) {
		this.getProcessing().fill(r, g, b,alpha);
	}

	public void drawBox(float rectX, float rectY, float rectWid, float rectHei, float rectRad, float r, float g, float b, float alpha) {
		this.getProcessing().fill(r, g, b,alpha);
		this.getProcessing().rect(rectX, rectY, rectWid, rectHei, rectRad);
	}

	public void drawStroke(boolean isStroke) {
		this.getProcessing().noStroke();
	}

	public void drawStroke(float strokeR, float strokeG, float strokeB, float strokeAlpha, float strokeWei) {
		this.getProcessing().stroke(strokeR, strokeG, strokeB, strokeAlpha);
		this.getProcessing().strokeWeight(strokeWei);
	}

	public void line(float x1, float y1, float x2, float y2) {
		this.getProcessing().line(x1, y1, x2, y2);
	}

	public EImage loadImage(String path) {
		return new ProcessingEImage(this.getProcessing().loadImage(path));
	}
}

class ProcessingEImage implements EImage {
	protected PImage img;
	protected PShape shape;
	private int width;
	private int height;

	public ProcessingEImage(PImage img) {
		this.img = img;
		this.width = this.img.width;
		this.height = this.img.height;
		this.updateShape();
	}

	private void updateShape() {
		this.shape = ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().createShape();
		this.shape.beginShape();
		this.shape.texture(this.img);
		this.shape.vertex(0, 0, 0, 0, 0);
		this.shape.vertex(this.width, 0, 0, this.img.width, 0);
		this.shape.vertex(this.width, this.height, 0, this.img.width, this.img.height);
		this.shape.vertex(0,  this.height, 0, 0, this.img.height);
		this.shape.endShape();
	}

	public int getWidth() {
		return this.width;
	}

	public int getHeight() {
		return this.height;
	}

	public void setWidth(int width) {
		this.width = width;
		this.updateShape();
	}

	public void setHeight(int height) {
		this.height = height;
		this.updateShape();
	}

	public void draw() {
		((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().shape(this.shape);
		//((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().image(this.img, 0, 0);
	}
}
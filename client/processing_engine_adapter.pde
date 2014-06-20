class ProcessingEngineAdapter implements EngineAdapter {
	private PFont[] fonts = new PFont[4];
	private int[] fontSize = new int[]{18, 24, 48, 64};
	private PApplet processing;
	public ProcessingEngineAdapter(PApplet processing) {
		this.processing = processing;

		this.getProcessing().frameRate(60);
		this.getProcessing().size(800, 600, P3D);

		for(int i=0; i<4; i++) {
			this.fonts[i] = this.getProcessing().createFont("NanumGothic", this.fontSize[i]);
		}
	}

	public int getWidth() {
		return 800;
	}

	public int getHeigth() {
		return 600;
	}

	public int getFrameRate() {
		return round(getProcessing().frameRate);
	}

	public PApplet getProcessing() {
		return this.processing;
	}

	public void drawFrameRate() {
		this.drawText("FPS : " + getFrameRate(), 10, 30);
	}

	public void drawText(String text, int x, int y) {
		this.drawText(text, x, y, 18);
	}

	public void drawText(String text, int x, int y, int size) {
		this.drawText(text, x, y, size, false);
	}

	public void drawText(String text, int x, int y, int size, boolean center) {
		if(center) {
			textAlign(CENTER, CENTER);
		} else {
			textAlign(LEFT);
		}
		
		for(int i=0; i<fontSize.length; i++) {
			if(fontSize[i] != size) continue;
			textFont(fonts[i], size);
		}
		textSize(size);
		text(text, x, y);
	}

	public void drawNotify(String text) {
		if(text == null || text.equals("")) return;

		this.getProcessing().fill(0, 0, 0, 160);
		rect(0, getHeigth() / 2 - 25, this.getWidth(), 50);
		this.getProcessing().fill(255);
		this.drawText(text, getWidth() / 2, getHeigth() / 2, 18, true);
	}

	public EImage loadImage(String path) {
		return new ProcessingEImage(this.getProcessing().loadImage(path));
	}
}

class ProcessingEImage implements EImage {
	private PImage img;

	public ProcessingEImage(PImage img) {
		this.img = img;
	}

	void draw() {
		((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().image(this.img, 0, 0);
	}
}
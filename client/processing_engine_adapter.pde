import ddf.minim.*;

class ProcessingEngineAdapter implements EngineAdapter {
	private PFont[] fonts = new PFont[6];
	private int[] fontSize = new int[]{8, 12, 18, 24, 48, 64};
	private PApplet processing;
	private Minim minim;
	private AudioPlayer bgmPlayer;
	private HashMap<Byte, EImage> tileImages = new HashMap<Byte, EImage>();
	private HashMap<String, ProcessingGameObjectImage> characterImages = new HashMap<String, ProcessingGameObjectImage>();
	private float nameLen;
	private float chatLen;
	private PShader gaussianBlurShader;

	public ProcessingEngineAdapter(PApplet processing) {
		this.processing = processing;

		this.getProcessing().frameRate(60);
		this.getProcessing().size(800, 600, "SanghyuckP3D");

		for(int i=0; i<6; i++) {
			this.fonts[i] = this.getProcessing().createFont("NanumGothic", this.fontSize[i]);
		}

		this.minim = new Minim(this.getProcessing());
		//this.gaussianBlurShader = this.getProcessing().loadShader("shaders/gaussian_blur.fs", "shaders/gaussian_blur.vs");


		SanghyuckInputMethod.getSanghyuckInputMethod().event = new SanghyuckInputMethodInputEvent() {
			public void inputEvent(String committedText, String composedText) {
				Engine.getInstance().inputEvent(committedText, composedText);
			/*
				if(committedText.length() > 0 ) {
					text += committedText;
					viewComposedText = "";
				} else {
					viewComposedText = composedText;
				}*/
			}
		};
	}

	public void runGameLoop() {
		if(bgmPlayer != null && !bgmPlayer.isPlaying()) {
			bgmPlayer.rewind();
			bgmPlayer.play();
		}

		this.drawText("FPS : " + getFrameRate(), 10, 30);
	}

	public void drawBefore() {
	}

	public void drawAfter() {
		//this.getProcessing().shader(this.gaussianBlurShader);
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

	public void drawTile(int x, int y, Tile tile) {
		if(tile.getResName() == null) return;
		if(!tileImages.containsKey(tile.getResId())) {
			EImage img = loadImage("data/tiles/" + tile.getResName() + ".png");
			img.setWidth(this.getWidth() / 24);
			img.setHeight(this.getWidth() / 24);
			tileImages.put(tile.getResId(), img);
		}

		this.getProcessing().translate(x, y);
		tileImages.get(tile.getResId()).draw();
		//Tile hpBar
		if(tile.isDrawHp() == true) {
			
			this.drawStroke(0, 0, 0, 255, 2);
			this.getProcessing().noFill();
			this.getProcessing().rect(5, 20, 20, 4);
			this.drawStroke(false);
			this.drawBox(5, 20, tile.getHp()/((float)tile.getMaxHp())*20, 4, PI/2, 255, 0, 0, 255);
			
		}

		this.getProcessing().translate(-x, -y);
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

	public void drawGameObject(int x, int y, GameObject obj) {
		if(obj.getEngineTag() == null) {
		}

		if(!this.characterImages.containsKey("1")) {
			ProcessingGameObjectImage img = new ProcessingGameObjectImage(this.getProcessing().loadImage("data/characters/" + "1" + ".png"));
			characterImages.put("1", img);
		}

		ProcessingGameObjectImage img = characterImages.get("1");

		//점프나 중력
		if(obj.getY() != obj.dest_y) {
			obj.setY(obj.getY() + 1);
		}

		if(obj.getX() != obj.dest_x/* || obj.getY() != obj.dest_y*/) {
			obj.moveTick += 1;
			if(obj.moveTick >= 40) {
				obj.moveTick = 0;
			}

			int dir = obj.getMoveDir();

			obj.setX(obj.getX() + (dir == 1 ? 1 : dir == 0 ? -1 : 0));
			if(obj.getX() < 0 || obj.getX() >= 80) {
				obj.move(obj.getDestMapId(), obj.getX() < 0 ? 79 : 0, obj.getY(),
					obj.getDestMapId(), obj.getDestX(), obj.getDestX());
			}
		} else {
			obj.moveTick = 0;
		}

		obj.setWidth(img.getWidth() / 4);
		obj.setHeight(img.getHeight() / 4);

		img.setDirection(4*obj.getDir() + (obj.moveTick / 10));

		int o_x = x + (img.getWidth() / 2);
		int o_y = y - img.getHeight();

		this.getProcessing().translate(o_x, o_y);
		img.draw();

		//weapon
		
		if(obj.getWeapon() != null){
			obj.getWeapon().draw();
		}


		this.getProcessing().rectMode(CENTER);

		if(!"".equals(obj.getName())) {
			nameLen = textWidth(obj.getName());
			this.getProcessing().fill(0, 0, 0, 160);
			this.getProcessing().rect((img.getWidth() / 2), img.getHeight() + 10, nameLen+10, 18, 7);
			this.getProcessing().fill(255);
			drawText(obj.getName() + obj.getUUID() , (img.getWidth() / 2), img.getHeight() + 10, 12, true);
		}

		if(obj.getHeadMessage() != null && !"".equals(obj.getHeadMessage())) {
			chatLen = textWidth(obj.getHeadMessage());
			this.getProcessing().fill(0, 0, 0, 160);
			this.getProcessing().rect((img.getWidth() / 2), -20, chatLen+20, 18, 7);
			this.getProcessing().fill(255);
			drawText(obj.getHeadMessage(), (img.getWidth() / 2), -20, 12, true);
		}

		this.getProcessing().rectMode(CORNER);
		this.getProcessing().translate(-o_x, -o_y);
	}
}

class ProcessingGameObjectImage extends ProcessingEImage {
	protected PShape[] shapeData;
	private int direction=0;

	public ProcessingGameObjectImage(PImage img) {
		super(img);
		this.setWidth(this.img.width / 4);
		this.setHeight(this.img.height / 4);
	}

	public void setDirection(int direction) {
		this.direction = direction;
	}

	protected void updateShape() {
		if(this.shapeData == null) {
			this.shapeData = new PShape[8];
		}
		int w = this.img.width / 4;
		int h = this.img.height / 4;
		
		for(int i=0; i<8; i++) {
			int x = (i+4)%4 * w;
			int y = (i+4)/4 * h;

			this.shapeData[i] = ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().createShape();
			this.shapeData[i].beginShape();
			this.shapeData[i].texture(this.img);
			this.shapeData[i].vertex(0, 0, 0, x, y);
			this.shapeData[i].vertex(this.getWidth(), 0, 0, x + w, y);
			this.shapeData[i].vertex(this.getWidth(), this.getHeight(), 0, x + w, y + h);
			this.shapeData[i].vertex(0,  this.getHeight(), 0, x, y + h);
			this.shapeData[i].endShape();
		}
	}

	public void draw() {
		((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().shape(this.shapeData[this.direction]);
	}
}

class ProcessingEImage implements EImage {
	protected PImage img;
	protected PShape shape;
	private int width;
	private int height;

	private float rad;

	private int x;
	private int y;

	public ProcessingEImage(PImage img) {
		this.img = img;
		this.width = this.img.width;
		this.height = this.img.height;
		this.updateShape();
	}

	protected void updateShape() {
		this.shape = ((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().createShape();
		this.shape.beginShape();
		this.shape.texture(this.img);
		this.shape.vertex(0, 0, 0, 0, 0);
		this.shape.vertex(this.width, 0, 0, this.img.width, 0);
		this.shape.vertex(this.width, this.height, 0, this.img.width, this.img.height);
		this.shape.vertex(0,  this.height, 0, 0, this.img.height);
		this.shape.endShape();
	}

	public int getX() {
		return this.x;
	}

	public int getY() {
		return this.y;
	}

	public void setX(int x) {
		this.x = x;
	}

	public void setY(int y) {
		this.y = y;
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
		((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().rotate(this.getRotate());
		((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().translate(this.getX(), this.getY());
		((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().shape(this.shape);
		((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().translate(-this.getX(), -this.getY());

	}

	public void setRotate(float rad) {
		this.rad = rad;
	}

	public float getRotate() {
		return this.rad;
	}
}
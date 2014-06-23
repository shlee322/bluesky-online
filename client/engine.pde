import java.util.concurrent.ConcurrentLinkedQueue;

public static class Engine implements EngineAdapter {
	private static Engine instance = new Engine();

	private EngineAdapter engineAdapter;
	private Scene scene;
	private Scene lastScene;
	private Network network = new Network();
	private UIManager uiManager = new UIManager();
	private ConcurrentLinkedQueue<Packet> packetQueue = new ConcurrentLinkedQueue<Packet>();

	private String notifyText;
	private int notifyTime;

	public static Engine getInstance() {
		return instance;
	}

	public void setEngineAdapter(EngineAdapter engineAdapter) {
		this.engineAdapter = engineAdapter;
	}

	private EngineAdapter getEngineAdapter() {
		return this.engineAdapter;
	}

	public int getWidth() {
		return getEngineAdapter().getWidth();
	}

	public int getHeight() {
		return getEngineAdapter().getHeight();
	}

	public UIManager getUIManager() {
		return uiManager;
	}

	public Network getNetwork() {
		return network;
	}

	public void clickScreen(int x, int y) {
		getUIManager().clickScreen(x, y);
	}

	public void init() {
		this.setScene(new IntroScene());
	}

	public void runGameLoop() {
	    if(this.scene != null) {
	        if(lastScene != scene) {
	            if(this.lastScene != null) {
	                this.lastScene.release();
	            }

	            this.lastScene = this.scene;
	            this.scene.init();
	        }

	        while(!this.packetQueue.isEmpty()) {
	        	this.scene.receivedPacket(this.packetQueue.poll());
	        }
	        this.scene.runSceneLoop();
	    }

	    getUIManager().runUILoop();

	    if(notifyTime != -1) {
	    	notifyTime -= 1;
	    	if(notifyTime == 0) notifyText = null;
	    }

	    getEngineAdapter().drawNotify(notifyText);
	    getEngineAdapter().runGameLoop();
	}

	public int getFrameRate() {
		return getEngineAdapter().getFrameRate();
	}

	public void setScene(Scene scene) {
		this.scene = scene;
	}

	public Scene getScene() {
		return this.scene;
	}

	public void showNotify(String text, int time) {
		this.notifyText = text;
		this.notifyTime = time;
	}

	public void playBGM(String path) {
		getEngineAdapter().playBGM(path);
	}

	public EImage loadImage(String path) {
		return getEngineAdapter().loadImage(path);
	}

	public void drawText(String text, int x, int y) {
		getEngineAdapter().drawText(text, x, y);
	}
	public void drawText(String text, int x, int y, int size) {
		getEngineAdapter().drawText(text, x, y, size);
	}
	public void drawText(String text, int x, int y, int size, boolean center) {
		getEngineAdapter().drawText(text, x, y, size, center);
	}

	//엔진에서만 호출할 수 있도록 함
	public void drawNotify(String text) {
		System.err.println("Engine용으로 개발된 메소드입니다. 외부에서 호출하실 수 없습니다.");
	}

	public void fill(float r, float g, float b, float alpha) {
		getEngineAdapter().fill(r, g, b,alpha);
	}

	public void drawBox(float rectX, float rectY, float rectWid, float rectHei, float rectRad, float r, float g, float b, float alpha) {
		getEngineAdapter().drawBox(rectX, rectY, rectWid, rectHei, rectRad, r, g, b, alpha);
	}
	public void drawStroke(boolean isStroke) {
		getEngineAdapter().drawStroke(isStroke);

	}
	public void drawStroke(float strokeR, float strokeG, float strokeB, float strokeAlpha, float strokeWei) {
		getEngineAdapter().drawStroke(strokeR, strokeG, strokeB, strokeAlpha, strokeWei);
	}

	public void line(float x1, float y1, float x2, float y2) {
		getEngineAdapter().line(x1, y1, x2, y2);
	}

	public void receivedPacket(Packet packet) {
		this.packetQueue.add(packet);
	}
}
public static class Engine implements EngineAdapter {
	private static Engine instance = new Engine();

	private EngineAdapter engineAdapter;
	private Scene scene;
	private Scene lastScene;
	private Network network = new Network();
	private UIManager uiManager = new UIManager();

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

	        this.scene.runSceneLoop();
	    }

	    getUIManager().runUILoop();

	    if(notifyTime != -1) {
	    	notifyTime -= 1;
	    	if(notifyTime == 0) notifyText = null;
	    }

	    getEngineAdapter().drawNotify(notifyText);
	    getEngineAdapter().drawFrameRate();
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
	public void drawFrameRate() {}
	public void drawNotify(String text) {}
}
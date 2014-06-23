interface EngineAdapter {
	int getWidth();
	int getHeight();
	int getFrameRate();
	void runGameLoop();
	void playBGM(String path);
	void drawText(String text, int x, int y);
	void drawText(String text, int x, int y, int size);
	void drawText(String text, int x, int y, int size, boolean center);
	void drawTile(int x, int y, String name);
	void drawNotify(String text);
	EImage loadImage(String path);
	void drawGameObject(int x, int y, GameObject obj);
}

interface EImage {
	void draw();
	int getWidth();
	int getHeight();
	void setWidth(int width);
	void setHeight(int height);
}
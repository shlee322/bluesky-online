interface EngineAdapter {
	int getWidth();
	int getHeigth();
	int getFrameRate();
	void drawFrameRate();
	void drawText(String text, int x, int y);
	void drawText(String text, int x, int y, int size);
	void drawText(String text, int x, int y, int size, boolean center);
	void drawNotify(String text);
	EImage loadImage(String path);
}

interface EImage {
	void draw();
}
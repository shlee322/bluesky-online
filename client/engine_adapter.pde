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
	void fill(float r, float g, float b, float alpha);
	void drawBox(float rectX, float rectY, float rectWid, float rectHei, float rectRad, float r, float g, float b, float alpha);
	void drawStroke(boolean isStroke);
	void drawStroke(float strokeR, float strokeG, float strokeB, float strokeAlpha, float strokeWei);
	void line(float x1, float y1, float x2, float y2);
	EImage loadImage(String path);
	void drawGameObject(int x, int y, GameObject obj);
}

interface EImage {
	void draw();
	int getWidth();
	int getHeight();
	void setWidth(int width);
	void setHeight(int height);
	int getX();
	int getY();
	void setX(int x);
	void setY(int y);
}
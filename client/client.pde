void setup() {
	Engine.getInstance().setEngineAdapter(new ProcessingEngineAdapter(client.this));
	Engine.getInstance().init();
}

void draw() {
	background(0);
    noStroke();
    try {
		Engine.getInstance().runGameLoop();
	} catch (Exception e) {
		e.printStackTrace();
	}
}

void mousePressed() {
	Engine.getInstance().clickScreen(mouseX, mouseY);
}

void keyPressed() {
	Engine.getInstance().keyPressed(key, keyCode);
}

void keyReleased() {
	//Engine.getInstance().keyReleased();
}

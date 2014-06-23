void setup() {
	Engine.getInstance().setEngineAdapter(new ProcessingEngineAdapter(client.this));
	Engine.getInstance().init();
}

void draw() {
	background(0);
    noStroke();
	Engine.getInstance().runGameLoop();
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

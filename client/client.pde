void setup() {
	Engine.getInstance().setEngineAdapter(new ProcessingEngineAdapter(client.this));
	Engine.getInstance().init();
}

void draw() {
	background(0);
    noStroke();
	Engine.getInstance().runGameLoop();
}
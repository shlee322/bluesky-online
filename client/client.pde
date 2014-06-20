void setup() {
	Engine.getInstance().setEngineAdapter(new ProcessingEngineAdapter(this));
	Engine.getInstance().init();
}

void draw() {
	background(0);
    noStroke();
	Engine.getInstance().runGameLoop();
}
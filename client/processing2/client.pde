void setup() {
  bluesky.client.engine.Engine.getInstance().setEngineAdapter(new ProcessingAdapter());
  bluesky.client.engine.Engine.getInstance().init();
  bluesky.client.engine.Engine.getInstance().setScene(new bluesky.client.login.LoginScene());
}

void draw() {
  bluesky.client.engine.Engine.getInstance().runGameLoop();
}

class ProcessingAdapter : bluesky.client.engine.EngineAdapter
{
  public void initEngine() {
  }
}
public static class UIComponent {
	private UIManager manager;
	private UIOnClickListener clickListener;

	public void setUIManager(UIManager manager) {
		this.manager = manager;
	}

	public UIManager getUIManager() {
		return this.manager;
	}

	public void loop() {
	}

	public void callClick(int x, int y) {
		this.clickListener.onClick(this, x, y);
	}
	public void setOnClickListener(UIOnClickListener listener) {
		this.clickListener = listener;
	}
	public boolean clickScreen(int x, int y) {
		return false;
	}
	public void inputEvent(String committedText, String composedText) {
	}
	public void keyPressed(char key, int keyCode) {
	}
	public boolean keyPressedHook(char key, int keyCode) {
		return false;
	}
	public void keyReleased() {
	}
	public boolean keyReleasedHook() {
		return false;
	}

}
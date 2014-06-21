public static class UIComponent {
	private UIManager manager;
	private UIOnClickListener clickListener;

	public void setUIManager(UIManager manager) {
		this.manager = manager;
	}
	
	public UIManager getUIManager() {
		return this.manager;
	}

	public void loop() {}
	public void callClick(int x, int y) {
		this.clickListener.onClick(this, x, y);
	}
	public void setOnClickListener(UIOnClickListener listener) {
		this.clickListener = listener;
	}
}
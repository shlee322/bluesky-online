import java.util.LinkedList;

public static class UIManager {
	private LinkedList<UIComponent> componentList = new LinkedList<UIComponent>();
	private UIComponent focus;

	public void runUILoop() {
		for(UIComponent comp : this.componentList) {
			comp.loop();
		}
	}

	public void addComponent(UIComponent comp) {
		this.componentList.add(comp);
		comp.setUIManager(this);
	}

	public void removeComponent(UIComponent comp) {
		this.componentList.remove(comp);
	}

	public void clearComponentList() {
		this.componentList.clear();
		this.focus = null;
	}

	public void clickScreen(int x, int y) {
		for(UIComponent comp : this.componentList) {
			if(comp.clickScreen(x, y)) return;
		}
		this.focus = null;
	}

	public UIComponent getFocusComponent() {
		return this.focus;
	}

	public void setFocusComponent(UIComponent comp) {
		this.focus = comp;
	}

	public boolean keyPressedHook(char key, int keyCode) {
		for(UIComponent comp : this.componentList) {
			if(comp.keyPressedHook(key, keyCode)) return true;
		}
		return false;
	}
}
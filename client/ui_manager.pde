import java.util.LinkedList;

public static class UIManager {
	private LinkedList<UIComponent> componentList = new LinkedList<UIComponent>();

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
	}

	public void clickScreen(int x, int y) {
		for(UIComponent comp : this.componentList) {
			if(comp.clickScreen(x, y)) return;
		}
	}
}
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
	}

	public void removeComponent(UIComponent comp) {
		this.componentList.remove(comp);
	}

	public void clearComponentList() {
		this.componentList.clear();
	}
}
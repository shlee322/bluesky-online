public static class UIEditBox extends UIComponent {
	private String text = "";
	private String composedText="";
	public int x;
	public int y;
	public int width = 200;
	public int height = 40;
	public int yy = 0;
	public int r;
	public int g;
	public int b;
	public boolean pw;
	public String emptyText="";

	public UIEditBox() {
	}

	public String getText() {
		return text + composedText;
	}

	public void setText(String text) {
		this.text = text;
		this.composedText = "";
	}

	public void loop() {
		String text = this.getText();
		if(pw) {
			int textLen = text.length();
			text="";
			for(int i=0; i<textLen; i++) text += "*";
		}

		if("".equals(getText()) && Engine.getInstance().getUIManager().getFocusComponent() != this){
			text = emptyText;
			(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing()).fill(0,0,0, 128);
		} else {
			(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing()).fill(0,0,0);
		}

		Engine.getInstance().drawText(text, x + 5, y + yy);
		(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing()).fill(255);
		if(Engine.getInstance().getUIManager().getFocusComponent() != this) return;
	}

	public boolean clickScreen(int x, int y) {
		if(this.x > x || this.y>y || (this.x+width) <= x || (this.y+height) <= y) return false;
		Engine.getInstance().getUIManager().setFocusComponent(this);
		//(((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing()).getComponents()[0].enableInputMethods(true);
		return true;
	}

	public void inputEvent(String committedText, String composedText) {
		if(committedText.length() > 0 ) {
			text += committedText;
			composedText = "";
		} else {
			composedText = composedText;
		}
	}

	public void keyPressed(char key, int keyCode) {
		if(keyCode == BACKSPACE) {
			if(text.length() < 1) return;
			text = text.substring(0, text.length() - 1);
			return;
		}
		text += String.valueOf(Character.toChars(key));
	}
}

void addListeners(java.awt.Component comp) {
  super.addListeners(comp);
  this.addInputMethodListener(SanghyuckInputMethod.getSanghyuckInputMethod());
  comp.addInputMethodListener(SanghyuckInputMethod.getSanghyuckInputMethod());
  this.enableInputMethods(true);
  comp.enableInputMethods(true);
  //((javax.media.opengl.awt.GLCanvas)this.getComponents()[0])
}

void removeListeners(java.awt.Component comp) {
  super.removeListeners(comp);
  this.removeInputMethodListener(SanghyuckInputMethod.getSanghyuckInputMethod());
  comp.removeInputMethodListener(SanghyuckInputMethod.getSanghyuckInputMethod());
  this.enableInputMethods(false);
  comp.enableInputMethods(false);
}
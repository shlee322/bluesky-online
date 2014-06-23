public static class UIEditBox extends UIComponent {
	public UIEditBox() {
		//((ProcessingEngineAdapter)Engine.getInstance().getEngineAdapter()).getProcessing().enableInputMethods(true);
	}
	public void loop() {
	}
}

String viewComposedText = "";
void inputMethodTextChanged() {
  if(committedText.length() > 0 ) {
    //print(committedText + "\n");
    viewComposedText = "";
  } else {
    viewComposedText = composedText;
  }
  print("committedText:" + committedText + ", composedText:" + composedText.charAt(0) + "\n");
}

public class InputMethodSystem<T>
 implements java.awt.event.InputMethodListener, java.awt.im.InputMethodRequests
{
  private Object applet;
  private java.lang.reflect.Method inputMethodTextChangedMethod;
  
  public InputMethodSystem(Object applet) {
    this.applet = applet;
    
    try {
      this.inputMethodTextChangedMethod = applet.getClass().getMethod("inputMethodTextChanged");
    } catch(NoSuchMethodException e) {
    }
  }
  
  public void inputMethodTextChanged(java.awt.event.InputMethodEvent event) {
  	System.out.println("inputMethodTextChanged");
    int committedCharacterCount = event.getCommittedCharacterCount();
    java.text.AttributedCharacterIterator text = event.getText();

    if (text != null) {
      StringBuilder committedTextBuilder = new StringBuilder();
      int toCopy = committedCharacterCount;
      char c = text.first();
      while (toCopy-- > 0) {
        committedTextBuilder.append(c);
        c = text.next();
      }
      committedText = committedTextBuilder.toString();
      composedText = String.valueOf(c);
    }
    if(event.getCaret() == null) {
      composedText = "";
    }
    event.consume();

    if(this.inputMethodTextChangedMethod != null) {
      try {
        this.inputMethodTextChangedMethod.invoke(this.applet, null);
      } catch(IllegalAccessException e) {
      } catch(java.lang.reflect.InvocationTargetException e) {
      }
    }
  }

  public void caretPositionChanged(java.awt.event.InputMethodEvent event) {
  	System.out.println("caretPositionChanged");
  }

  public java.awt.Rectangle getTextLocation(java.awt.font.TextHitInfo offset) {
  	System.out.println("getTextLocation");
    return null;
  }

  public java.awt.font.TextHitInfo getLocationOffset(int x, int y) {
  	System.out.println("getLocationOffset");
    return null;
  }

  public int getInsertPositionOffset() {
  	System.out.println("getInsertPositionOffset");
    return 0;
  }

  public java.text.AttributedCharacterIterator getCommittedText(int beginIndex, int endIndex, java.text.AttributedCharacterIterator.Attribute[] attributes) {
    System.out.println("getCommittedText");
    return null;
  }

  public int getCommittedTextLength() {
  	System.out.println("getCommittedTextLength");
    return 0;
  }

  public java.text.AttributedCharacterIterator cancelLatestCommittedText(java.text.AttributedCharacterIterator.Attribute[] attributes) {
  	System.out.println("cancelLatestCommittedText");
    return null;
  }

  public java.text.AttributedCharacterIterator getSelectedText(java.text.AttributedCharacterIterator.Attribute[] attributes) {
  	System.out.println("getSelectedText");
    return null;
  }
}

String committedText="";
String composedText="";
InputMethodSystem inputMethodSystem = new InputMethodSystem(this);

void addListeners(java.awt.Component comp) {
  super.addListeners(comp);
  this.addInputMethodListener(inputMethodSystem);
  comp.addInputMethodListener(inputMethodSystem);
  this.enableInputMethods(true);
  comp.enableInputMethods(true);
  //((javax.media.opengl.awt.GLCanvas)this.getComponents()[0])
}

void removeListeners(java.awt.Component comp) {
  super.removeListeners(comp);
  this.addInputMethodListener(inputMethodSystem);
  comp.removeInputMethodListener(inputMethodSystem);
  this.enableInputMethods(false);
  comp.enableInputMethods(false);
}

java.awt.im.InputMethodRequests getInputMethodRequests() {
  return inputMethodSystem;
}
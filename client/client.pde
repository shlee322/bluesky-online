/**
* 프로세싱에서 상속받는 클라이언트의 메인 코드입니다.
* 이곳에서 Bluesky Online에게 이벤트를 넘겨줍니다.
*
* @author Lee Sanghyuck <shlee322@elab.kr>
**/

/**
* 프로세싱의 초기화 메소드입니다.
*/
void setup() {
	Engine.getInstance().setEngineAdapter(new ProcessingEngineAdapter(client.this));
	Engine.getInstance().init();
}

/**
* 프로세싱의 드로우 메소드이며 매 프레임마다 호출됩니다.
*/
void draw() {
	background(0);
    noStroke();
    try {
		Engine.getInstance().runGameLoop();
	} catch (Exception e) {
		e.printStackTrace();
	}
}

/**
* 마우스 클릭이 발생하면 호출되는 메소드입니다.
*/
void mousePressed() {
	Engine.getInstance().clickScreen(mouseX, mouseY);
}

/**
* 키 입력이 발생하면 호출되는 메소드입니다.
*/
void keyPressed() {
	Engine.getInstance().keyPressed(key, keyCode);
}

/**
* 키 입력이 해지되면 호출되는 메소드입니다.
*/
void keyReleased() {
	//Engine.getInstance().keyReleased();
}

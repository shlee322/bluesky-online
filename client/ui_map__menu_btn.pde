public static class MenuBtnComponent extends UIComponent {
    public void loop() {
        Engine.getInstance().getEngineAdapter().drawStroke(0, 0, 0, 255, 2);
        Engine.getInstance().getEngineAdapter().drawBox(700, 20, 16, 50, PI/2, 66, 139, 202, 255);
        Engine.getInstance().getEngineAdapter().drawBox(720, 20, 16, 50, PI/2, 66, 139, 202, 255);
        Engine.getInstance().getEngineAdapter().drawBox(740, 20, 16, 50, PI/2, 66, 139, 202, 255);
        Engine.getInstance().getEngineAdapter().drawBox(760, 20, 16, 50, PI/2, 66, 139, 202, 255);
    }
    public boolean clickScreen(int x, int y) {
        if(x>=700 && x<780 && y>=20 && y<70) {
            this.callClick(x, y);
            return true;
        }
        return false;
    }
}
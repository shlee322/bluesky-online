public static class Inventory extends UIComponent {
    public void loop() {
        Engine.getInstance().getEngineAdapter().drawStroke(255, 255, 255, 100, 1);
        Engine.getInstance().getEngineAdapter().drawBox(90, 15, 40, 40, 0, 0, 0, 0, 0);  
        Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
    }
    
    public boolean clickScreen(int x, int y) {
        if(x>=90 && x<130 && y>=15 && y<55) {
            this.callClick(x, y);
            return true;
        }
        return false;
    }
}

public static class Inventory_full extends UIComponent {
    int slot;
    public void loop() {
        Engine.getInstance().getEngineAdapter().drawStroke(255, 255, 255, 100, 1);
        Engine.getInstance().getEngineAdapter().drawBox(65, 75, 670, 450, 10, 66, 139, 202, 255);
        Engine.getInstance().getEngineAdapter().drawBox(255, 155, 450, 352, 10, 66, 139, 202, 255);  

        for(int x=0;x<3;x++){
           Engine.getInstance().getEngineAdapter().line(255,155+88*(x+1),705,155+88*(x+1));
        }
        for(int x=0;x<5;x++){
            Engine.getInstance().getEngineAdapter().line(255+75*(x+1),155,255+75*(x+1), 507);
        }
        Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
        for(int x = 0 ; x<24; x++){
            Engine.getInstance().drawText(String.valueOf(Inven.getInstance().getInventory(x)), 255+75*(x%6)+30, 155+88*(x/6)+30, 30, true);
        }
    }
    
    public boolean clickScreen(int x, int y) {
        for(int a=0; a<24;a++){
            if(x>=255+75*(a%6) && x<255+75*(a%6)+75 && y>=155+88*(a/6) && y<155+88*(a/6)+88){
                slot = a;
                this.callClick(x,y);
                return true;
            }
        }
        return false;
    }

}
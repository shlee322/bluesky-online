public static class LoginScene implements Scene, UIOnClickListener {
    private EImage bg;
    private UIEditBox id;
    private UIEditBox pw;
    private UIEditBox name;

    private void initLoginBox() {
        Engine.getInstance().getUIManager().clearComponentList();


        /*
        Engine.getInstance().getUIManager(); //을 통하여 UI Manager을 사용할 수 있음
        */

        
        UIComponent loginBoxComp = new LoginBoxComponent();
        UIComponent loginBtnComp = new LoginBtnComponent();
        UIComponent signUpBtnComp = new SignUpBtnComponent();
        loginBtnComp.setOnClickListener(this);
        signUpBtnComp.setOnClickListener(this);
        Engine.getInstance().getUIManager().addComponent(loginBoxComp);
        Engine.getInstance().getUIManager().addComponent(loginBtnComp);
        Engine.getInstance().getUIManager().addComponent(signUpBtnComp);

        id = new UIEditBox();
        id.x = 270;
        id.y = 350;
        id.yy = 30;
        id.emptyText = "ID";
        Engine.getInstance().getUIManager().addComponent(id);

        pw = new UIEditBox();
        pw.x = 270;
        pw.y = 350 + 45;
        pw.yy = 30;
        pw.pw = true;
        pw.emptyText = "Password";
        Engine.getInstance().getUIManager().addComponent(pw);
    }

    private void initRegisterBox() {
        Engine.getInstance().getUIManager().clearComponentList();

        UIComponent signUpBoxComp = new SignUpBoxComponent();
        UIComponent registerBtnComp = new RegisterBtnComponent();
        UIComponent goBackBtnComp = new GoBackBtnComponent();
        registerBtnComp.setOnClickListener(this);
        goBackBtnComp.setOnClickListener(this);
        Engine.getInstance().getUIManager().addComponent(signUpBoxComp);
        Engine.getInstance().getUIManager().addComponent(registerBtnComp);
        Engine.getInstance().getUIManager().addComponent(goBackBtnComp);

        id = new UIEditBox();
        id.x = 270;
        id.y = 310;
        id.yy = 30;
        id.emptyText = "ID";
        Engine.getInstance().getUIManager().addComponent(id);

        pw = new UIEditBox();
        pw.x = 270;
        pw.y = 310 + 45;
        pw.yy = 30;
        pw.pw = true;
        pw.emptyText = "Password";
        Engine.getInstance().getUIManager().addComponent(pw);

        name = new UIEditBox();
        name.x = 270;
        name.y = 310 + 45 + 45;
        name.yy = 30;
        name.emptyText = "Name";
        Engine.getInstance().getUIManager().addComponent(name);
    }

    @Override
    public void init() {
        this.bg = Engine.getInstance().loadImage("images/intro.png");
        this.bg.setWidth(Engine.getInstance().getWidth());
        this.bg.setHeight(Engine.getInstance().getHeight());

        Engine.getInstance().getUIManager().clearComponentList();

        this.initLoginBox();
    }

    @Override
    public void runSceneLoop() {
        this.bg.draw();
        Engine.getInstance().fill(255, 255, 255, 255);
        Engine.getInstance().drawText("BlueSky Online", Engine.getInstance().getWidth() / 2, 150, 64, true);
    }

    @Override
    public void release() {
    }

    @Override
    public void receivedPacket(Packet packet) {
    }

    @Override
    public void onClick(UIComponent comp, int x, int y) {
        if(comp instanceof LoginBtnComponent) {
            Engine.getInstance().showNotify("로그인 시도중 입니다...", -1);
            Engine.getInstance().getNetwork().write(new CS_Login(id.getText(), pw.getText()));
        }
        if(comp instanceof SignUpBtnComponent) {
            initRegisterBox();
        }
        if(comp instanceof RegisterBtnComponent) {
            initLoginBox();
        }
        if(comp instanceof GoBackBtnComponent) {
            initLoginBox();
        }
    }

    private class LoginBoxComponent extends UIComponent {
        public void loop() {
            Engine.getInstance().getEngineAdapter().drawStroke(false);
            Engine.getInstance().getEngineAdapter().drawBox(220, 300, 360, 246, 30, 200, 200, 200, 100);   //loginBox

            Engine.getInstance().getEngineAdapter().drawStroke(66, 139, 202, 100, 2);
            Engine.getInstance().getEngineAdapter().drawBox(270, 350, 260, 90, 10, 255, 255, 255, 100);    //login

            Engine.getInstance().getEngineAdapter().drawStroke(66, 139, 202, 255, 1);
            Engine.getInstance().getEngineAdapter().line(270, 395, 530, 395);                           //login line
        }
    }

    private class LoginBtnComponent extends UIComponent {
        public void loop() {
            Engine.getInstance().getEngineAdapter().drawStroke(255, 255, 255, 100, 1);
            Engine.getInstance().getEngineAdapter().drawBox(270, 460, 120, 46, 10, 66, 139, 202, 255);    //signIn
            Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
            Engine.getInstance().getEngineAdapter().drawText("Sign In", 300, 490, 23, false);
        }
        
        public boolean clickScreen(int x, int y) {
            if(x>=270 && x<390 && y>=460 && y<506) {
                this.callClick(x, y);
                return true;
            }
            return false;
        }

    }

    private class SignUpBtnComponent extends UIComponent {
        public void loop() {
            Engine.getInstance().getEngineAdapter().drawStroke(255, 255, 255, 100, 1);
            Engine.getInstance().getEngineAdapter().drawBox(410, 460, 120, 46, 10, 66, 139, 202, 255);    //sighUp 
            Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
            Engine.getInstance().getEngineAdapter().drawText("Sign Up", 432, 490, 23, false);
        }

        public boolean clickScreen(int x, int y) {
            if(x>=410 && x<530 && y>=460 && y<506) {
                this.callClick(x, y);
                return true;
            }
            return false;
        }
    }

    private class SignUpBoxComponent extends UIComponent {
        public void loop() {
            Engine.getInstance().getEngineAdapter().drawStroke(false);
            Engine.getInstance().getEngineAdapter().drawBox(200, 270, 405, 246, 30, 200, 200, 200, 100);   //loginBox

            Engine.getInstance().getEngineAdapter().drawStroke(66, 139, 202, 100, 2);
            Engine.getInstance().getEngineAdapter().drawBox(270, 305, 260, 135, 10, 255, 255, 255, 100);    //SignUpBtn

            Engine.getInstance().getEngineAdapter().drawStroke(66, 139, 202, 255, 1);
            Engine.getInstance().getEngineAdapter().line(270, 350, 530, 350);                           //login line1

            Engine.getInstance().getEngineAdapter().drawStroke(66, 139, 202, 255, 1);
            Engine.getInstance().getEngineAdapter().line(270, 395, 530, 395);                           //login line2
        }
    }

    private class RegisterBtnComponent extends UIComponent {
        public void loop() {
            Engine.getInstance().getEngineAdapter().drawStroke(255, 255, 255, 100, 1);
            Engine.getInstance().getEngineAdapter().drawBox(270, 460, 120, 46, 10, 66, 139, 202, 255);    //signIn
            Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
            Engine.getInstance().getEngineAdapter().drawText("Register", 291, 490, 23, false);
        }
        
        public boolean clickScreen(int x, int y) {
            if(x>=270 && x<390 && y>=460 && y<506) {
                this.callClick(x, y);
                return true;
            }
            return false;
        }

    }

    private class GoBackBtnComponent extends UIComponent {
        public void loop() {
            Engine.getInstance().getEngineAdapter().drawStroke(255, 255, 255, 100, 1);
            Engine.getInstance().getEngineAdapter().drawBox(410, 460, 120, 46, 10, 66, 139, 202, 255);    //sighUp 
            Engine.getInstance().getEngineAdapter().fill(255, 255, 255, 255);
            Engine.getInstance().getEngineAdapter().drawText("Go Back", 427, 490, 23, false);
        }

        public boolean clickScreen(int x, int y) {
            if(x>=410 && x<530 && y>=460 && y<506) {
                this.callClick(x, y);
                return true;
            }
            return false;
        }
    }
}

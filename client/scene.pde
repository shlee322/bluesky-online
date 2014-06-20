/**
 * Scene
 *
 * 일종의 컨트롤러 개념으로 볼 수 있으며 Engine과 소통하면서 실질적인 그래픽 작업을 진행하게 됨
 *
 * @author Lee Sanghyuck(shlee322@elab.kr)
 */
public interface Scene {
    void init();
    void runSceneLoop();
    void release();
}

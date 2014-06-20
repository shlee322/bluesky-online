/**
 * Game Model
 *
 * 게임 모델은 싱글톤 패턴에 따르며 Scene가 변경될 경우 init, release가 호출된다.
 *
 * @author Lee Sanghyuck(shlee322@elab.kr)
 */
public interface Model {
    void init(Scene scene);
    void release(Scene scene);
}
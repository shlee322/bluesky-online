package bluesky.client.engine;

/**
 * 엔진에서 객체에 Tag 등을 부여할 수 있게 만들기 위한 인터페이스
 * 사용 예로는 그래픽 관련 클래스 태깅 등이 존재.
 */
public interface EngineEntity {
    void setEngineTag(Object o);
    Object getEngineTag();
}

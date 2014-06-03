package bluesky.client.engine;

/**
 * 그래픽 처리등 엔진에서 요청하는 처리를 직접 처리하는 인터페이스
 * 
 */
public interface EngineAdapter {
    void initEngine();
    int getWidth();
    int getHeight();

}

package client.item;

/**
 * Created by Hong on 2014-06-19.
 */

public class Item {

    int[] GraphicCode = new int[255];
    boolean[][] ItemTag = new boolean[255][8];
    //체력 등 저장?;
    private static Item instance = new Item();

    Item() {
        for (int x = 0; x < 255; x++) {
            GraphicCode[x] = x;
            for (int y = 0; y < 8; y++) {
                ItemTag[x][y] = true; //일단 모든 태그 다 true처리 해놓음
            }
        }
    }

    public static Item getInstance() {
        return instance;
    }

    public boolean ContainTag(int GraphicCode, int i) {
        return ItemTag[GraphicCode][i]; //GraphicCode의 i 태그가 포함되있는지 확인한다.
    }
    /**
     * 각각의 아이템은 고유 식별 넘버, 아이템 코드, 아이템 태그가 있다.
     * <p/>
     * 0 - 조합 가능
     * 1 - 입을 수 있음 (모자, 옷, 신발, 장갑 등)
     * 2 - 무기류의 날로 쓸 수 있음 (곡괭이, 도끼, 칼의 날 등)
     * 3 - 1자로 가공 가능 (무기류의 손잡이나 막대기)
     * 4 - 3에서 가공된것
     * 5 - 블럭
     * 6 - 재료 (레드스톤등)
     * 7 - 도구
     * <p/>
     * <p/>
     * '3' 태그를 가지고 있으면 단일 가공 가능 ( 나무 -> 막대기 4개, 철 -> 철 막대 4개)
     */

    //생성자

}

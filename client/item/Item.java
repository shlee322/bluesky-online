package client.item;

/**
 * Created by Hong on 2014-06-19.
 */

import java.util.ArrayList;

public class Item implements ItemTag {
    private int count, id;
    private ArrayList<Integer> ItemTag = new ArrayList();

    /**
    각각의 아이템은 고유 식별 넘버, 아이템 코드, 아이템 태그가 있다.

    0 - 조합 가능
    1 - 입을 수 있음 (모자, 옷, 신발, 장갑 등)
    2 - 무기류의 날로 쓸 수 있음 (곡괭이, 도끼, 칼 등)
    3 - 1자로 가공 가능 (무기류의 손잡이나 막대기)
    4 - 3에서 가공된것


    '3' 태그를 가지고 있으면 단일 가공 가능 ( 나무 -> 막대기 4개, 철 -> 철 막대 4개)
    */

    //생성자

    @Override
    public ArrayList<Integer> getItemTag() {
        return ItemTag;
    }

    @Override
    public void setItemTag(int itemTag) {
        ItemTag.add(itemTag);
    }

    public int getId() {
        return id;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getCount() {
        return count;
    }

    public void DropItem() {
    }

}

package client.item;

/**
 * Created by Hong on 2014-06-19.
 */

public class Equipment {
    int durability, GraphicCode;

    Equipment(int GraphicCode) {
        this.GraphicCode = GraphicCode;
        //GraphicCode에 따라서 durability 설정
    }

    void useItem() {
        if (durability == 0) {
            //객체 삭제
        } else {
            this.durability--;
        }
    }
}

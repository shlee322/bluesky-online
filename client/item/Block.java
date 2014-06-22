package client.item;

/**
 * Created by Hong on 2014-06-19.
 * hardness 말고 이미 TileResource class가 존재.
 */

public class Block extends Item implements Installable {
    int hardness;

    public void setHardness(int hardness) {
        this.hardness = hardness;
    }

    public int getHardness() {
        return hardness;
    }

    @Override
    public void install(Block b) {
        int num = this.getCount();
        this.setCount(num -= 1);
        //수량을 줄였다.
        //그리고 설치를 해야한다.
    }
}

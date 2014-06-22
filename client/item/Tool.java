package client.item;

/**
 * Created by Hong on 2014-06-19.
 */
public class Tool extends Item implements Wearable {
    int durability;

    public void setDurability(int durability) {
        this.durability = durability;
    }

    public int getDurability() {
        return durability;
    }

    public void BreakTool(Tool t) {
        if (t.getDurability() == 0) {
            //내구도 0, 부순다.
            int num = this.getCount();
            this.setCount(num -= 1);
        }
    }

    @Override
    public void wear() {
        //입자
    }
}

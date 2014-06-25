
/**
 * Created by Hong on 2014-06-22.'
 */
public static class Inven {
    int[] Inventory = new int[24];//6*4
    int[] ItemNumber = new int[24];
    private static client.Inven instance = new client.Inven();

    Inven() { //처음 인벤 생성시 모든 칸, 칸당 갯수 0(null) 값을 준다.
        for (int x = 0; x < 24; x++) {
            Inventory[x] = 0;
            ItemNumber[x] = 0;
        }
    }

    public static client.Inven getInstance() {
        return instance;
    }

    public int getInventory(int i){
        return Inventory[i];
    }

    public int getItemNumber(int i){
        return ItemNumber[i];
    }
    public void getItem(int GrahpicCode) {
        for (int x = 0; x < 24; x++) {
            if (Inventory[x] == GrahpicCode) {
                ItemNumber[x]++;
                return;
            } else if (Inventory[x] == 0) {
                Inventory[x] = GrahpicCode;
                ItemNumber[x]++;
                return;
            }
        }
    }

    public void useItem(int GrahpicCode) {
        for (int x = 23; x == 0; x--) {
            if (Inventory[x] == GrahpicCode && ItemNumber[x] > 0) {
                ItemNumber[x]--;
                if (ItemNumber[x] == 0) {
                    Inventory[x] = 0;
                }
                return;
            }
        }
    }
}

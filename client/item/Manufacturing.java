package client.item;


/**
 * Created by Hong on 2014-06-20.
 * <p/>
 * 조합창
 * 6 7 8
 * 3 4 5
 * 0 1 2
 */
public class Manufacturing {
    private boolean canMixing = true;
    private boolean[] tableChk = new boolean[9];


    public void Manufacture(MixTable m) {
        for (int x = 0; x < 9; x++) {
            if (m.getItemMakeOn(x) != 0) { //x가 비지 않을 경우
                tableChk[x] = true;
                if (Item.getInstance().ContainTag(m.getItemMakeOn(x), 0)) { //x 아이템이 0(조합 가능을 포함하면)
                } else {
                    canMixing = false;
                }
            } else { //비었을경우 체크 안하고 그냥 둔다.
            }
        }

        if (canMixing) {
            FindItemRecipe findItemRecipe = new FindItemRecipe();
            String str = findItemRecipe.Find(tableChk);
            boolean canMix = false;
            if (str.equals("axe")) {
                //태그 검사
            }
            if (canMix) {
                for (int x = 0; x < 9; x++) {
                    if (m.getItemMakeOn(x) != 0) { //x가 비지 않을 경우
                        Inventory.getInstance().useItem(m.getItemMakeOn(x));
                    }
                }
                //  Inventory.getInstance().getItem(도끼);
            } else if (str.equals("nife")) {

                if (canMix) {
                }
            } else if (str.equals("pickax")) {

                if (canMix) {
                }
            } else if (str.equals("helmet")) {

                if (canMix) {
                }
            } else if (str.equals("armor")) {

                if (canMix) {
                }
            } else if (str.equals("gloves")) {

                if (canMix) {
                }
            } else if (str.equals("shoes")) {
                if (canMix) {
                }
            } else {
            }
        }
        /**
         * 무기 - 도끼 00X, 칼 XOX, 곡괭이 OOO
         *             X0X     XOX         XOX
         *             X0X     XOX         XOX
         *
         * 막대기 - 나무, 다이아, 철, 등등  아무데나 O 한개
         * 옷 - 투구 OOO, 옷 OXO, 장갑 OXO, 신발 XXX
         *           OXO     OOO       OXO       OXO
         *           XXX     OOO       XXX       OXO
         *
         *
         *           1. 얼마나 차있는지 조사 (tableChk[]를 이용해서 레시피 조사)
         *           2. 그거에 따라 케이스 분류 (무엇인가)
         *           3. 태그가 일치하는지 조사
         *           4. 만들기
         * */


    }

}


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
            if (str.equals("axe")) {
                if (Item.getInstance().ContainTag(m.getItemMakeOn(1), 4) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(4), 4) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(6), 2) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(7), 2)) {
                    for (int x = 0; x < 9; x++) {
                        if (m.getItemMakeOn(x) != 0) {
                            Inven.getInstance().useItem(m.getItemMakeOn(x));
                        }
                    } //만들기

                }

            } else if (str.equals("nife")) {
                if (Item.getInstance().ContainTag(m.getItemMakeOn(1), 4) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(4), 2) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(7), 2)) {
                    for (int x = 0; x < 9; x++) {
                        if (m.getItemMakeOn(x) != 0) {
                            Inven.getInstance().useItem(m.getItemMakeOn(x));
                        }
                    }
                }
            } else if (str.equals("pickax")) {
                if (Item.getInstance().ContainTag(m.getItemMakeOn(1), 4) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(4), 4) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(6), 2) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(7), 2) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(8), 2)) {
                    for (int x = 0; x < 9; x++) {
                        if (m.getItemMakeOn(x) != 0) {
                            Inven.getInstance().useItem(m.getItemMakeOn(x));
                        }
                    }
                }

            } else if (str.equals("helmet")) {
                if (Item.getInstance().ContainTag(m.getItemMakeOn(3), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(5), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(6), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(7), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(8), 1)) {
                    for (int x = 0; x < 9; x++) {
                        if (m.getItemMakeOn(x) != 0) {
                            Inven.getInstance().useItem(m.getItemMakeOn(x));
                        }
                    }
                }
            } else if (str.equals("armor")) {
                if (Item.getInstance().ContainTag(m.getItemMakeOn(0), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(1), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(2), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(3), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(4), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(5), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(6), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(8), 1)) {
                    for (int x = 0; x < 9; x++) {
                        if (m.getItemMakeOn(x) != 0) {
                            Inven.getInstance().useItem(m.getItemMakeOn(x));
                        }
                    }
                }

            } else if (str.equals("gloves")) {
                if (Item.getInstance().ContainTag(m.getItemMakeOn(3), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(5), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(6), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(8), 1)) {
                    for (int x = 0; x < 9; x++) {
                        if (m.getItemMakeOn(x) != 0) {
                            Inven.getInstance().useItem(m.getItemMakeOn(x));
                        }
                    }
                }
            } else if (str.equals("shoes")) {
                if (Item.getInstance().ContainTag(m.getItemMakeOn(0), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(2), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(3), 1) &&
                        Item.getInstance().ContainTag(m.getItemMakeOn(5), 1)) {
                    for (int x = 0; x < 9; x++) {
                        if (m.getItemMakeOn(x) != 0) {
                            Inven.getInstance().useItem(m.getItemMakeOn(x));
                        }
                    }
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

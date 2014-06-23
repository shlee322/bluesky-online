
package client.item;

import java.util.ArrayList;

/**
 * Created by Hong on 2014-06-20.
 */

public class FindItemRecipe {

    ArrayList<Recipe> aRecipe = new ArrayList<Recipe>();


    String Find(boolean[] b) {
        CodeLoad();
        String temp = "";
        for (int x = 0; x < 9; x++) {
            if (b[x]) {
                temp = temp.concat("1");
            } else {
                temp = temp.concat("0");
            }
        }
        for (int i = 0; i < aRecipe.size(); i++) {
            if (aRecipe.get(i).Code.equals(temp)) {
                return aRecipe.get(i).Name;
            } else {
            }
        }
        return "NONE";
    }

    /**
     * 무기 - 도끼 00X, 칼 XOX, 곡괭이 OOO
     * X0X     XOX         XOX
     * X0X     XOX         XOX
     * <p/>
     * 막대기 - 나무, 다이아, 철, 등등  아무데나 O 한개
     * 옷 - 투구 OOO, 갑옷 OXO, 장갑 OXO, 신발 XXX
     * OXO       OOO       OXO       OXO
     * XXX       OOO       XXX       OXO
     * <p/>
     * <p/>
     * 1. 얼마나 차있는지 조사 (tableChk[]를 이용해서 레시피 조사)
     * 2. 그거에 따라 케이스 분류 (무엇인가)
     * 3. 태그가 일치하는지 조사
     * 4. 만들기
     */


    void CodeLoad() {
        Recipe axe = new Recipe("axe", "010010110");
        Recipe nife = new Recipe("nife", "010010010");
        Recipe pickax = new Recipe("pickax", "010010111");
        Recipe helmet = new Recipe("helmet", "000101111");
        Recipe armor = new Recipe("armor", "111111101");
        Recipe gloves = new Recipe("gloves", "000101101");
        Recipe shoes = new Recipe("shoes", "010010000");
        //stick
        aRecipe.add(axe);
        aRecipe.add(nife);
        aRecipe.add(pickax);
        aRecipe.add(helmet);
        aRecipe.add(armor);
        aRecipe.add(gloves);
        aRecipe.add(shoes);

    }
}

class Recipe {
    String Name, Code;

    Recipe(String name, String code) {
        this.Name = name;
        this.Code = code;
    }
}
package kr.elab.game.bluesky.server.map;

public class PrimitiveTile implements ITile {
    private static PrimitiveTile[] tiles = new PrimitiveTile[20];

    public static PrimitiveTile getPrimitiveTile(int code) {
        if(tiles[code] == null) {
            //차후 동기화 이슈 해결
            tiles[code] = new PrimitiveTile(code);
        }

        return tiles[code];
    }

    private int resId;

    private PrimitiveTile(int res) {
        this.resId = res;
    }

    @Override
    public int getResId() {
        return this.resId;
    }
}

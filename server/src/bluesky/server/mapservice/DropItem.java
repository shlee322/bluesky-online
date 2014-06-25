package bluesky.server.mapservice;

public class DropItem {
    private static long itemUUID = 0;

    private long uuid = itemUUID++;
    private int x;
    private int y;
    private byte resId;

    public DropItem(int x, int y, byte resId) {
        this.x = x;
        this.y = y;
        this.resId = resId;
    }

    public int getX() {
        return this.x;
    }

    public int getY() {
        return this.y;
    }

    public long getUUID() {
        return this.uuid;
    }

    public byte getResId() {
        return this.resId;
    }
}

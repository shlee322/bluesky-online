package bluesky.server.mapservice;

import org.msgpack.annotation.Message;

@Message
public class DropItem {
    private static long itemUUID = 0;

    public long uuid = itemUUID++;
    public int x;
    public int y;
    public byte resId;

    public DropItem() {}

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

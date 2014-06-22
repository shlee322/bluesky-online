package bluesky.server.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 일단 급한관계로 커넥션 풀은 차후 구현
 */
public class DBManager {
    private static DBManager instance = new DBManager();
    public static DBManager getInstance() { return instance; }

    public DBManager() {
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost/bluesky", "bluesky", "bluesky");
    }
}

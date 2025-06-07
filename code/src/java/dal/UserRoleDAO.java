package dal;

import java.sql.*;

public class UserRoleDAO {
    private Connection conn;
    public UserRoleDAO(Connection conn) { this.conn = conn; }

    public void assignRoleToUser(int userId, int roleId) throws SQLException {
        String sql = "INSERT INTO UserRole(user_id, role_id) VALUES (?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, roleId);
        ps.executeUpdate();
    }
}
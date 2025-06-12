package dal;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class UserRoleDAO {
    private final Connection conn;
    public UserRoleDAO(Connection conn) { this.conn = conn; }

    public void assignRoleToUser(int userId, int roleId) throws SQLException {
        String sql = "INSERT INTO UserRole(user_id, role_id) VALUES (?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, roleId);
        ps.executeUpdate();
    }
    
    public Map<Integer, String> getUserRoleNamesMap() throws SQLException {
    Map<Integer, String> map = new HashMap<>();
    String sql = "SELECT ur.user_id, r.name FROM UserRole ur JOIN Roles r ON ur.role_id = r.id";
    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            map.put(rs.getInt("user_id"), rs.getString("name"));
        }
    }
    return map;
}
}
package dal;

import java.sql.*;
import java.util.*;
import model.Role;

public class RoleDAO {
    private Connection conn;
    public RoleDAO(Connection conn) { this.conn = conn; }

    public List<Role> getRolesByUserId(int userId) throws SQLException {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT r.* FROM Roles r JOIN UserRole ur ON r.id = ur.role_id WHERE ur.user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Role(rs.getInt("id"), rs.getString("name")));
        }
        return list;
    }
}
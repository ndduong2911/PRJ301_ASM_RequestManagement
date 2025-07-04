package dal;

import java.sql.*;
import java.util.*;
import model.User;

public class UserDAO {

    private Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    public UserDAO() {
    }

    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("full_name"),
                    rs.getInt("division_id"),
                    rs.getObject("manager_id") != null ? rs.getInt("manager_id") : null
            );
        }
        return null;
    }

    public List<User> getUsersByManager(int managerId) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE manager_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, managerId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("full_name"),
                    rs.getInt("division_id"),
                    rs.getObject("manager_id") != null ? rs.getInt("manager_id") : null
            ));
        }
        return list;
    }

    public void registerUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (username, password, full_name, division_id, manager_id) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getPassword());
        ps.setString(3, user.getFullName());
        ps.setInt(4, user.getDivisionId());
        if (user.getManagerId() != null) {
            ps.setInt(5, user.getManagerId());
        } else {
            ps.setNull(5, Types.INTEGER);
        }
        ps.executeUpdate();
    }

    public List<User> getAllManagers() throws SQLException {
        String sql = "SELECT DISTINCT u.* FROM Users u "
                + "JOIN UserRole ur ON u.id = ur.user_id "
                + "JOIN Roles r ON ur.role_id = r.id "
                + "WHERE r.name IN (N'Trưởng nhóm', N'Division Leader')";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        List<User> list = new ArrayList<>();
        while (rs.next()) {
            list.add(new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("full_name"),
                    rs.getInt("division_id"),
                    rs.getObject("manager_id") != null ? rs.getInt("manager_id") : null
            ));
        }
        return list;
    }

    public int registerUserReturnId(User user) throws SQLException {
        String sql = "INSERT INTO Users (username, password, full_name, division_id, manager_id) OUTPUT INSERTED.id VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getPassword());
        ps.setString(3, user.getFullName());
        ps.setInt(4, user.getDivisionId());

        if (user.getManagerId() != null) {
            ps.setInt(5, user.getManagerId());
        } else {
            ps.setNull(5, java.sql.Types.INTEGER);
        }

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
        return -1;
    }

    public boolean hasDivisionLeader(int divisionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users u "
                + "JOIN UserRole ur ON u.id = ur.user_id "
                + "JOIN Roles r ON ur.role_id = r.id "
                + "WHERE r.name = N'Division Leader' AND u.division_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, divisionId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
        return false;
    }

    public Map<Integer, String> getAllManagerRoles() throws SQLException {
        Map<Integer, String> map = new HashMap<>();
        String sql = """
        SELECT ur.user_id, r.name 
        FROM UserRole ur 
        JOIN Roles r ON ur.role_id = r.id
    """;
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("user_id"), rs.getString("name"));
            }
        }
        return map;
    }

    public List<User> getAllManagersWithRoleAndDivision() throws SQLException {
        String sql = """
        SELECT u.id, u.full_name, r.name AS role_name, d.name AS division_name
        FROM Users u
        JOIN UserRole ur ON u.id = ur.user_id
        JOIN Roles r ON ur.role_id = r.id
        JOIN Divisions d ON u.division_id = d.id
        WHERE r.name != 'Nhân viên'
        """;
        List<User> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("full_name"));
                u.setRoleName(rs.getString("role_name"));
                u.setDivisionName(rs.getString("division_name"));
                list.add(u);
            }
        }
        return list;
    }

    public List<User> getUsersByDivision(int divisionId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE division_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, divisionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id")); // ✅ cần thiết
                u.setFullName(rs.getString("full_name"));
                u.setUsername(rs.getString("username"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM Users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getInt("division_id"),
                        rs.getObject("manager_id") != null ? rs.getInt("manager_id") : null
                );
            }
        }
        return null;
    }
    
      public void createUser(User user) throws SQLException {
        String sql = "INSERT INTO Users(username, password, full_name, manager_id, division_id) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, null);
            ps.setString(3, user.getFullName());
            ps.setObject(4, user.getManagerId());
            ps.setObject(5, user.getDivisionId());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                user.setId(rs.getInt(1));
            }
        }
    }

    public void assignRole(int userId, int roleId) throws SQLException {
        String sql = "INSERT INTO UserRole(user_id, role_id) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roleId);
            ps.executeUpdate();
        }
    }
}



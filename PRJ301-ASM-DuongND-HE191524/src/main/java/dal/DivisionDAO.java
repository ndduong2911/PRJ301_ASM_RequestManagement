package dal;

import java.sql.*;
import java.util.*;
import model.Division;

public class DivisionDAO {
    private Connection conn;

    public DivisionDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Division> getAllDivisions() throws SQLException {
        List<Division> list = new ArrayList<>();
        String sql = "SELECT * FROM Divisions";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Division(rs.getInt("id"), rs.getString("name")));
        }
        return list;
    }
    
    public Division getDivisionById(int id) throws SQLException {
        String sql = "SELECT id, name FROM Divisions WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Division(rs.getInt("id"), rs.getString("name"));
                }
            }
        }
        return null;
    }
}

package dal;

import java.sql.*;
import java.util.*;
import model.Feature;

public class FeatureDAO {
    private Connection conn;
    public FeatureDAO(Connection conn) { this.conn = conn; }

    public List<Feature> getFeaturesByRoleId(int roleId) throws SQLException {
        List<Feature> list = new ArrayList<>();
        String sql = "SELECT f.* FROM Features f JOIN RoleFeature rf ON f.id = rf.feature_id WHERE rf.role_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, roleId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Feature(rs.getInt("id"), rs.getString("name"), rs.getString("path")));
        }
        return list;
    }
}
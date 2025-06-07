package dal;

import java.sql.*;

public class RoleFeatureDAO {
    private Connection conn;
    public RoleFeatureDAO(Connection conn) { this.conn = conn; }

    public void assignFeatureToRole(int roleId, int featureId) throws SQLException {
        String sql = "INSERT INTO RoleFeature(role_id, feature_id) VALUES (?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, roleId);
        ps.setInt(2, featureId);
        ps.executeUpdate();
    }
}

package dal;

import java.sql.*;
import java.util.*;
import model.Request;

public class RequestDAO {
    private Connection conn;
    public RequestDAO(Connection conn) { this.conn = conn; }

    public void createRequest(Request request) throws SQLException {
        String sql = "INSERT INTO Requests (title, from_date, to_date, reason, status, created_by) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, request.getTitle());
        ps.setDate(2, request.getFromDate());
        ps.setDate(3, request.getToDate());
        ps.setString(4, request.getReason());
        ps.setString(5, request.getStatus());
        ps.setInt(6, request.getCreatedBy());
        ps.executeUpdate();
    }

    public List<Request> getRequestsByUser(int userId) throws SQLException {
        List<Request> list = new ArrayList<>();
        String sql = "SELECT * FROM Requests WHERE created_by = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapResultSetToRequest(rs));
        }
        return list;
    }

    private Request mapResultSetToRequest(ResultSet rs) throws SQLException {
        return new Request(
            rs.getInt("id"),
            rs.getString("title"),
            rs.getDate("from_date"),
            rs.getDate("to_date"),
            rs.getString("reason"),
            rs.getString("status"),
            rs.getInt("created_by"),
            rs.getObject("processed_by") != null ? rs.getInt("processed_by") : null,
            rs.getString("processed_note")
        );
    }
}
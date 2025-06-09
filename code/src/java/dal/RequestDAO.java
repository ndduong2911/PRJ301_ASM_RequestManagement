package dal;

import java.sql.*;
import java.util.*;
import model.Request;
import static model.Request.fromResultSet;

public class RequestDAO {

    private Connection conn;

    public RequestDAO(Connection conn) {
        this.conn = conn;
    }

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
        String sql = "SELECT r.*, u.full_name as creatorName, p.full_name as processorName "
                + "FROM Requests r "
                + "JOIN Users u ON r.created_by = u.id "
                + "LEFT JOIN Users p ON r.processed_by = p.id "
                + "WHERE r.created_by = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        List<Request> list = new ArrayList<>();
        while (rs.next()) {
            Request r = fromResultSet(rs);
            r.setCreatedByName(rs.getString("creatorName"));
            r.setProcessedByName(rs.getString("processorName"));
            list.add(r);
        }
        return list;
    }

    public List<Request> getRequestsByManagedUsers(int managerId) throws SQLException {
        String sql = "SELECT r.*, u.full_name as creatorName, p.full_name as processorName, u.manager_id "
                + "FROM Requests r "
                + "JOIN Users u ON r.created_by = u.id "
                + "LEFT JOIN Users p ON r.processed_by = p.id "
                + "WHERE u.manager_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, managerId);
        ResultSet rs = ps.executeQuery();
        List<Request> list = new ArrayList<>();
        while (rs.next()) {
            Request r = fromResultSet(rs);
            r.setCreatedByName(rs.getString("creatorName"));
            r.setProcessedByName(rs.getString("processorName"));
            r.setManagerId(rs.getObject("manager_id") != null ? rs.getInt("manager_id") : null);
            list.add(r);
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

    public Request getRequestById(int id) throws SQLException {
        String sql = "SELECT * FROM Requests WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return mapResultSetToRequest(rs);
        }
        return null;
    }

    public void updateRequest(int id, java.sql.Date from, java.sql.Date to, String reason) throws SQLException {
        String sql = "UPDATE Requests SET from_date = ?, to_date = ?, reason = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ps.setString(3, reason);
            ps.setInt(4, id);
            ps.executeUpdate();
        }
    }

    public void updateStatus(int requestId, String status, String note, int processedBy) throws SQLException {
        String sql = "UPDATE Requests SET status = ?, processed_note = ?, processed_by = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, note);
            ps.setInt(3, processedBy);
            ps.setInt(4, requestId);
            ps.executeUpdate();
        }
    }

    public boolean hasOverlappingRequest(int userId, java.sql.Date fromDate, java.sql.Date toDate) throws SQLException {
        String sql = """
        SELECT 1
        FROM Requests
        WHERE created_by = ?
          AND status = 'Inprogress'
          AND (
              (from_date <= ? AND to_date >= ?)  -- Giao nhau với khoảng đã chọn
          )
    """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, toDate);   // khoảng chọn đến ngày
            ps.setDate(3, fromDate); // khoảng chọn từ ngày

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Nếu có ít nhất 1 bản ghi nghĩa là trùng
            }
        }
    }

    public void deleteRequest(int id) throws SQLException {
        String sql = "DELETE FROM Requests WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

}

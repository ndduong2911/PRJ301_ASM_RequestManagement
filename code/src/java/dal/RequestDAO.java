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
            r.setProcessedNote(rs.getString("processed_note"));
            list.add(r);
        }
        return list;
    }

    public List<Request> getRequestsByManagedUsers(int managerId) throws SQLException {
        String sql = "SELECT r.*, "
                + "u.full_name AS creatorName, "
                + "p.full_name AS processorName, "
                + "d.name AS divisionName "
                + "FROM Requests r "
                + "JOIN Users u ON r.created_by = u.id "
                + "LEFT JOIN Users p ON r.processed_by = p.id "
                + "JOIN Divisions d ON u.division_id = d.id "
                + "WHERE u.manager_id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, managerId);
        ResultSet rs = ps.executeQuery();

        List<Request> list = new ArrayList<>();
        while (rs.next()) {
            Request r = new Request();
            r.setId(rs.getInt("id"));
            r.setTitle(rs.getString("title"));
            r.setFromDate(rs.getDate("from_date"));
            r.setToDate(rs.getDate("to_date"));
            r.setReason(rs.getString("reason"));
            r.setStatus(rs.getString("status"));
            r.setCreatorName(rs.getString("creatorName"));
            r.setDivisionName(rs.getString("divisionName"));
            r.setProcessedNote(rs.getString("processed_note"));
            r.setProcessedByName(rs.getString("processorName")); // ✅ Dòng bạn đang hỏi
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

    public boolean updateRequestStatus(int requestId, String status, int processorId, String note) throws SQLException {
        String sql = "UPDATE Requests SET status = ?, processed_by = ?, processed_note = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, processorId);
            ps.setString(3, note);
            ps.setInt(4, requestId);
            return ps.executeUpdate() > 0;
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

    // Truyền thêm cả divisionId và isManager để phân biệt quyền
    public List<Request> getRequestsOfSubordinates(int managerId, int divisionId, boolean isManager) throws SQLException {
    String sql;

    if (isManager) {
        // Division Leader: xem toàn bộ đơn của division mình
        sql = """
            SELECT r.*, 
                   u.full_name AS creator_name, 
                   d.name AS division_name, 
                   p.full_name AS processor_name
            FROM Requests r
            JOIN Users u ON r.created_by = u.id
            JOIN Divisions d ON u.division_id = d.id
            LEFT JOIN Users p ON r.processed_by = p.id
            WHERE u.division_id = ?
        """;
    } else {
        // Trưởng nhóm: xem đơn của nhân viên cấp dưới
        sql = """
            SELECT r.*, 
                   u.full_name AS creator_name, 
                   d.name AS division_name, 
                   p.full_name AS processor_name
            FROM Requests r
            JOIN Users u ON r.created_by = u.id
            JOIN Divisions d ON u.division_id = d.id
            LEFT JOIN Users p ON r.processed_by = p.id
            WHERE u.manager_id = ?
        """;
    }

    List<Request> list = new ArrayList<>();
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        if (isManager) {
            ps.setInt(1, divisionId);
        } else {
            ps.setInt(1, managerId);
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Request r = new Request();
                r.setId(rs.getInt("id"));
                r.setTitle(rs.getString("title"));
                r.setFromDate(rs.getDate("from_date"));
                r.setToDate(rs.getDate("to_date"));
                r.setReason(rs.getString("reason"));
                r.setStatus(rs.getString("status"));
                r.setCreatorName(rs.getString("creator_name"));
                r.setDivisionName(rs.getString("division_name"));
                r.setProcessedNote(rs.getString("processed_note"));
                r.setProcessedByName(rs.getString("processor_name")); // ✅ dòng fix chính
                list.add(r);
            }
        }
    }
    return list;
}

    public Request getById(int id) throws SQLException {
        String sql = "SELECT r.*, u.full_name AS creatorName, d.name AS divisionName "
                + "FROM Requests r "
                + "JOIN Users u ON r.created_by = u.id "
                + "JOIN Divisions d ON u.division_id = d.id "
                + "WHERE r.id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Request r = new Request();
                r.setId(rs.getInt("id"));
                r.setTitle(rs.getString("title"));
                r.setFromDate(rs.getDate("from_date"));
                r.setToDate(rs.getDate("to_date"));
                r.setReason(rs.getString("reason"));
                r.setStatus(rs.getString("status"));
                r.setCreatorName(rs.getString("creatorName"));
                r.setDivisionName(rs.getString("divisionName"));
                r.setProcessedNote(rs.getString("processed_note"));
                return r;
            }
        }
        return null;
    }
}
package model;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Request {

    private int id;
    private String title;
    private Date fromDate;
    private Date toDate;
    private String reason;
    private String status;
    private int createdBy;
    private Integer processedBy;
    private String processedNote;
    private String createdByName;
    private String processedByName;
    private Integer managerId;

    public Request() {
    }

    public Request(int id, String title, Date fromDate, Date toDate, String reason, String status,
            int createdBy, Integer processedBy, String processedNote) {
        this.id = id;
        this.title = title;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.reason = reason;
        this.status = status;
        this.createdBy = createdBy;
        this.processedBy = processedBy;
        this.processedNote = processedNote;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Integer getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Integer processedBy) {
        this.processedBy = processedBy;
    }

    public String getProcessedNote() {
        return processedNote;
    }

    public void setProcessedNote(String processedNote) {
        this.processedNote = processedNote;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getProcessedByName() {
        return processedByName;
    }

    public void setProcessedByName(String processedByName) {
        this.processedByName = processedByName;
    }

    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
    }

    public static Request fromResultSet(ResultSet rs) throws SQLException {
        Request r = new Request();
        r.setId(rs.getInt("id"));
        r.setTitle(rs.getString("title"));
        r.setFromDate(rs.getDate("from_date"));
        r.setToDate(rs.getDate("to_date"));
        r.setReason(rs.getString("reason"));
        r.setStatus(rs.getString("status"));
        r.setCreatedBy(rs.getInt("created_by"));

        int processedBy = rs.getInt("processed_by");
        if (!rs.wasNull()) {
            r.setProcessedBy(processedBy);
        }

        return r;
    }
    
    public boolean isManagedBy(int managerId) {
    return this.managerId != null && this.managerId == managerId;
}
}

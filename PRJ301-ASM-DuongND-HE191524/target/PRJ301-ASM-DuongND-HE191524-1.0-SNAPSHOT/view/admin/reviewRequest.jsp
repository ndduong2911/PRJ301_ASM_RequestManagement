<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Request" %>
<%
    Request requestData = (Request) session.getAttribute("reviewRequest");
    String error = (String) session.getAttribute("error");
    String success = (String) session.getAttribute("success");
    session.removeAttribute("error");
    session.removeAttribute("success");

    if (requestData == null) {
        response.sendRedirect("index.jsp?feature=approve");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn nghỉ phép</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="container mt-5">
    <h3 class="mb-4">Chi tiết đơn nghỉ phép</h3>

    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } else if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>

    <table class="table table-bordered">
        <tr><th>Tiêu đề</th><td><%= requestData.getTitle() %></td></tr>
        <tr><th>Từ ngày</th><td><%= requestData.getFromDate() %></td></tr>
        <tr><th>Đến ngày</th><td><%= requestData.getToDate() %></td></tr>
        <tr><th>Lý do</th><td><%= requestData.getReason() %></td></tr>
        <tr><th>Người tạo</th><td><%= requestData.getCreatorName() %></td></tr>
        <tr><th>Phòng ban</th><td><%= requestData.getDivisionName() %></td></tr>
        <tr><th>Trạng thái hiện tại</th><td><%= requestData.getStatus() %></td></tr>
        <tr><th>Ghi chú xử lý</th><td><%= requestData.getProcessedNote() != null ? requestData.getProcessedNote() : "Chưa có" %></td></tr>
    </table>

<form action="<%= request.getContextPath() %>/request/process" method="post">
        <input type="hidden" name="id" value="<%= requestData.getId() %>"/>
        <div class="mb-3">
            <label for="note" class="form-label">Ghi chú:</label>
            <textarea name="note" id="note" rows="3" class="form-control"></textarea>
        </div>
        <button type="submit" name="action" value="approve" class="btn btn-success">✅ Duyệt đơn</button>
        <button type="submit" name="action" value="reject" class="btn btn-danger">❌ Từ chối</button>
<a href="<%= request.getContextPath() %>/request/approve" class="btn btn-secondary">⬅ Quay lại</a>

    </form>
</body>
</html>
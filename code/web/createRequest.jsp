<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo đơn xin nghỉ phép</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow">
            <div class="card-header bg-primary text-white text-center">
                <h4>Tạo đơn xin nghỉ phép</h4>
            </div>
            <div class="card-body">

                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
                <% } %>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                <% } %>

                <!-- ✅ Fix đường dẫn action bị sai -->
                <form action="${pageContext.request.contextPath}/request/create" method="post">
                    <div class="mb-3">
                        <label for="fromDate" class="form-label">Từ ngày:</label>
                        <input type="date" class="form-control" id="fromDate" name="fromDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="toDate" class="form-label">Đến ngày:</label>
                        <input type="date" class="form-control" id="toDate" name="toDate" required>
                    </div>
                    <div class="mb-3">
                        <label for="reason" class="form-label">Lý do:</label>
                        <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-success w-100">Gửi đơn</button>
                </form>

            </div>
            <div class="card-footer text-center text-muted">
                PRJ301 Leave System
            </div>
        </div>
    </div>
</body>
</html>

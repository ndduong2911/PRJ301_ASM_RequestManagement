<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Request, model.User" %>
<%
    Request requestObj = (Request) request.getAttribute("request");
    User currentUser = (User) session.getAttribute("user");
    if (requestObj == null || currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Duyệt đơn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body>
    <div class="container mt-5">
        <h4 class="mb-4 text-primary">Duyệt đơn xin nghỉ phép</h4>

        <p><strong>Duyệt bởi:</strong> <%= currentUser.getFullName() %></p>
        <p><strong>Tạo bởi:</strong> <%= requestObj.getCreatorName() %></p>
        <p><strong>Phòng ban:</strong> <%= requestObj.getDivisionName() %></p>
        <p><strong>Từ ngày:</strong> <%= requestObj.getFromDate() %></p>
        <p><strong>Đến ngày:</strong> <%= requestObj.getToDate() %></p>
        <p><strong>Lý do:</strong></p>
        <div class="border p-2 bg-light mb-3"><%= requestObj.getReason() %></div>

        <form action="request/process" method="post" class="d-flex gap-2">
            <input type="hidden" name="requestId" value="<%= requestObj.getId() %>"/>
            <textarea name="note" class="form-control me-2" placeholder="Lý do duyệt hoặc từ chối" required></textarea>
            <button type="submit" name="action" value="reject" class="btn btn-danger">Reject</button>
            <button type="submit" name="action" value="approve" class="btn btn-success">Approve</button>
        </form>
    </div>
</body>
</html>
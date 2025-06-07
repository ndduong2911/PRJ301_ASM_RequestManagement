<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Request"%>
<%
    Request r = (Request) request.getAttribute("request");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xét duyệt đơn</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <h2>Xét duyệt đơn nghỉ phép</h2>
    <form action="review" method="post">
        <input type="hidden" name="id" value="<%= r.getId() %>"/>

        <div class="mb-2">
            <label><strong>Tiêu đề:</strong></label>
            <p><%= r.getTitle() %></p>
        </div>

        <div class="mb-2">
            <label><strong>Từ ngày:</strong></label>
            <p><%= r.getFromDate() %></p>
        </div>

        <div class="mb-2">
            <label><strong>Đến ngày:</strong></label>
            <p><%= r.getToDate() %></p>
        </div>

        <div class="mb-2">
            <label><strong>Lý do:</strong></label>
            <p><%= r.getReason() %></p>
        </div>

        <div class="mb-3">
            <label for="note"><strong>Ghi chú xử lý:</strong></label>
            <textarea name="note" id="note" class="form-control" rows="3" required></textarea>
        </div>

        <button type="submit" name="action" value="approve" class="btn btn-success">Approve</button>
        <button type="submit" name="action" value="reject" class="btn btn-danger">Reject</button>
    </form>
</body>
</html>

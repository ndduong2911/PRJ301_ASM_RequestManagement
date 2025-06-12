<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Request"%>
<%
    Request r = (Request) request.getAttribute("requestToEdit");
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Sửa đơn nghỉ phép</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="container mt-5">

        <%-- Toast --%>
        <% if (success != null || error != null) { %>
        <div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 9999;">
            <div class="toast align-items-center text-bg-<%= success != null ? "success" : "danger" %> border-0 show" role="alert">
                <div class="d-flex">
                    <div class="toast-body">
                        <%= success != null ? "✅ " + success : "❌ " + error %>
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        </div>
        <% } %>

        <h3>Sửa đơn nghỉ phép</h3>

<form action="<%= request.getContextPath() %>/request/edit" method="post">
            <input type="hidden" name="id" value="<%= r.getId() %>">
            <div class="mb-3">
                <label>Từ ngày:</label>
                <input type="date" class="form-control" name="fromDate" value="<%= r.getFromDate() %>" required>
            </div>
            <div class="mb-3">
                <label>Đến ngày:</label>
                <input type="date" class="form-control" name="toDate" value="<%= r.getToDate() %>" required>
            </div>
            <div class="mb-3">
                <label>Lý do:</label>
                <textarea class="form-control" name="reason" required><%= r.getReason() %></textarea>
            </div>
            <div class="d-flex gap-2">
                <button class="btn btn-success">Cập nhật</button>
                <a href="<%= request.getContextPath() %>/request/delete?id=<%= r.getId() %>" class="btn btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa đơn này không?');">Xóa</a>
                <a href="<%= request.getContextPath() %>/request/list" class="btn btn-secondary">Quay về xem đơn của tôi</a>
            </div>
        </form>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    setTimeout(() => {
                        const toastEl = document.querySelector('.toast');
                        if (toastEl) {
                            const bsToast = bootstrap.Toast.getOrCreateInstance(toastEl);
                            bsToast.hide();
                        }
                    }, 2000);
        </script>
    </body>
</html>
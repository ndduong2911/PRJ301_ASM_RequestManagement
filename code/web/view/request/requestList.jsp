<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Request"%>
<%@ page import="model.Role" %>
<%@ page import="model.User" %>
<%@ page import="dal.RoleDAO" %>
<%
    List<Request> list = (List<Request>) request.getAttribute("requests");
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách đơn nghỉ phép</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
    </head>
    <body class="container mt-4">
        <h2>Đơn xin nghỉ phép</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Tiêu đề</th>
                    <th>Từ ngày</th>
                    <th>Đến ngày</th>
                    <th>Lý do</th>
                    <th>Trạng thái</th>
                    <th>Người tạo</th>
                    <th>Xử lý bởi</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (list != null) {
                        for (Request r : list) {
                %>
                <tr>
                    <td><%= r.getTitle() %></td>
                    <td><%= r.getFromDate() %></td>
                    <td><%= r.getToDate() %></td>
                    <td><%= r.getReason() %></td>
                    <td><%= r.getStatus() %></td>
                    <td><%= r.getCreatedByName() %></td>
                    <td><%= r.getProcessedByName() %></td>
                    <td>
                        <% if (r.getCreatedBy() == currentUser.getId() && "Inprogress".equals(r.getStatus())) { %>
                     <a href="<%= request.getContextPath() %>/request/edit?id=<%= r.getId() %>" class="btn btn-warning btn-sm">Sửa</a>
                        <% } %>
                        <% if (r.isManagedBy(currentUser.getId())) { %>
                       <a href="<%= request.getContextPath() %>/request/review?id=<%= r.getId() %>" class="btn btn-primary btn-sm">Xét duyệt</a>

                        <% } %>
                    </td>
                </tr>
                <%      }
                    }
                %>
            </tbody>
        </table>
    </body>

    <% String success = request.getParameter("success");
       String error = request.getParameter("error");
       String updated = request.getParameter("updated");
    %>

    <% if ("1".equals(success)) { %>
    <div class="alert alert-success" role="alert">
        ✅ Đơn đã gửi thành công!
    </div>
    <% } else if ("1".equals(error)) { %>
    <div class="alert alert-danger" role="alert">
        ❌ Có lỗi xảy ra khi gửi đơn. Vui lòng thử lại.
    </div>
    <% } else if ("1".equals(updated)) { %>
    <div class="alert alert-info" role="alert">
        ℹ️ Đơn đã được cập nhật thành công.
    </div>
    <% } %>
</html>

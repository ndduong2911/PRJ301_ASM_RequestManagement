<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Role, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<Role> roles = (List<Role>) session.getAttribute("roles");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Trang chính</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body { font-family: Arial; }
        .content { padding: 40px; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold text-success" href="#">RequestSystem</a>
        <div class="collapse navbar-collapse justify-content-end">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <span class="nav-link">Xin chào, <strong><%= user.getFullName() %></strong></span>
                </li>
                <li class="nav-item">
                    <form action="logout" method="post" class="d-inline">
                        <button class="btn btn-outline-danger btn-sm" type="submit">Đăng xuất</button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Nội dung -->
<div class="container content">
    <h3>Thông tin tài khoản</h3>
    <p><strong>Username:</strong> <%= user.getUsername() %></p>

    <h4>Vai trò:</h4>
    <ul>
        <% for (Role r : roles) { %>
            <li><%= r.getName() %></li>
        <% } %>
    </ul>

    <h4>Chức năng:</h4>
    <ul>
        <li><a href="request/create">Tạo đơn nghỉ phép</a></li>
        <li><a href="request/list">Xem đơn của tôi</a></li>

        <%-- Nếu là Trưởng nhóm hoặc Trưởng phòng thì được phép duyệt đơn --%>
        <%
            for (Role r : roles) {
                if (r.getName().equalsIgnoreCase("Trưởng nhóm") || r.getName().equalsIgnoreCase("Division Leader")) {
        %>
            <li><a href="request/review">Xét duyệt đơn</a></li>
        <%
                    break;
                }
            }
        %>

        <%-- Nếu là Division Leader thì được xem agenda --%>
        <%
            for (Role r : roles) {
                if (r.getName().equalsIgnoreCase("Division Leader")) {
        %>
            <li><a href="agenda">Xem Agenda</a></li>
        <%
                    break;
                }
            }
        %>
    </ul>
</div>

</body>
</html>

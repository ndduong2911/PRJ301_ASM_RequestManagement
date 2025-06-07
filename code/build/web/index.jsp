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
</head>
<body>
    <h2>Xin chào, <%= user.getFullName() %>!</h2>
    <p>Username: <%= user.getUsername() %></p>

    <h3>Vai trò:</h3>
    <ul>
        <% if (roles != null) {
            for (Role r : roles) {
        %>
            <li><%= r.getName() %></li>
        <%  }} %>
    </ul>

    <h3>Chức năng</h3>
    <ul>
        <li><a href="request/create">Tạo đơn nghỉ phép</a></li>
        <li><a href="request/list">Xem đơn của tôi</a></li>

        <%-- Nếu là Trưởng nhóm hoặc Trưởng phòng thì được phép duyệt đơn --%>
        <%
            if (roles != null) {
                for (Role r : roles) {
                    if (r.getName().equalsIgnoreCase("Trưởng nhóm") || r.getName().equalsIgnoreCase("Division Leader")) {
        %>
                        <li><a href="request/review">Xét duyệt đơn</a></li>
        <%
                        break;
                    }
                }
            }
        %>

        <%-- Nếu là Division Leader thì được xem agenda --%>
        <%
            if (roles != null) {
                for (Role r : roles) {
                    if (r.getName().equalsIgnoreCase("Division Leader")) {
        %>
                        <li><a href="agenda">Xem Agenda</a></li>
        <%
                        break;
                    }
                }
            }
        %>
    </ul>
</body>
</html>

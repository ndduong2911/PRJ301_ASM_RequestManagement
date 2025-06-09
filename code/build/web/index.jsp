<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Role, model.Request, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<Role> roles = (List<Role>) session.getAttribute("roles");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String activeFeature = request.getParameter("feature");

    // Lấy thông báo thành công/thất bại từ session
    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");

    List<Request> myRequests = (List<Request>) session.getAttribute("myRequests");
    session.removeAttribute("myRequests");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Trang chính - Request System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            font-family: Arial;
        }
        .sidebar {
            height: 100vh;
            background-color: #007bff;
            color: white;
            padding: 20px;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 8px 10px;
            border-radius: 4px;
        }
        .sidebar a.active {
            background-color: aqua;
            color: black;
        }
        .content {
            padding: 30px;
        }
    </style>
</head>

<body class="d-flex">

<!-- Sidebar -->
<div class="sidebar">
    <h5>👤 <%= user.getFullName() %></h5>
    <hr/>
    <p><strong>Vai trò:</strong></p>
    <ul>
        <% for (Role r : roles) { %>
            <li><%= r.getName() %></li>
        <% } %>
    </ul>
    <hr/>
    <a href="<%= request.getContextPath() %>/index.jsp?feature=create" class="<%= "create".equals(activeFeature) ? "active" : "" %>">📝 Tạo đơn nghỉ phép</a>
    <a href="request/list" class="<%= "list".equals(activeFeature) ? "active" : "" %>">📄 Xem đơn của tôi</a>
</div>

<!-- Nội dung -->
<div class="flex-grow-1">
    <nav class="d-flex justify-content-end p-3">
        <form action="logout" method="post">
            <button class="btn btn-outline-danger btn-sm">Đăng xuất</button>
        </form>
    </nav>

    <div class="container content">

        <% if ("list".equals(activeFeature)) { %>
            <h3>Danh sách đơn nghỉ phép</h3>
            <% if (myRequests == null || myRequests.isEmpty()) { %>
                <div class="alert alert-info">Bạn chưa có đơn nghỉ phép nào.</div>
            <% } else { %>
                <table class="table table-bordered table-striped">
                    <thead>
                    <tr>
                        <th>Tiêu đề</th>
                        <th>Từ ngày</th>
                        <th>Đến ngày</th>
                        <th>Lý do</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Request r : myRequests) { %>
                        <tr>
                            <td><%= r.getTitle() %></td>
                            <td><%= r.getFromDate() %></td>
                            <td><%= r.getToDate() %></td>
                            <td><%= r.getReason() %></td>
                            <td>
                                <%= r.getStatus() %>
                                <% if ("Inprogress".equalsIgnoreCase(r.getStatus())) { %>
                                    <a href="<%= request.getContextPath() + "/request/edit?id=" + r.getId() %>" class="btn btn-sm btn-warning">Sửa</a>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        <% } else { %>
            <!-- Tạo đơn nghỉ -->
            <div class="card shadow">
                <div class="card-header bg-primary text-white text-center">
                    <h4>Tạo đơn xin nghỉ phép</h4>
                </div>
                <div class="card-body">
                    <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                    <% } else if (success != null) { %>
                        <div class="alert alert-success"><%= success %></div>
                    <% } %>

                    <form action="request/create" method="post">
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
                    Hệ thống quản lý đơn nghỉ phép
                </div>
            </div>
        <% } %>
    </div>
</div>

<!-- Toast chỉ hiển thị khi feature=list (tức sau khi sửa đơn) -->
<% if ("list".equals(activeFeature)) { %>
    <% if (success != null) { %>
        <div class="alert alert-success alert-dismissible fade show position-fixed top-0 end-0 m-4 shadow" role="alert" style="z-index: 9999;">
            ✅ <strong><%= success %></strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show position-fixed top-0 end-0 m-4 shadow" role="alert" style="z-index: 9999;">
            ❌ <strong><%= error %></strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

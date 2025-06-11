<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Division, model.User, model.Role"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký tài khoản</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            background: linear-gradient(135deg, #667eea, #764ba2);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
        }

        .container {
            background: #fff;
            padding: 40px 50px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            max-width: 800px;
            width: 100%;
        }

        .form-control {
            height: 45px;
            border-radius: 8px;
        }

        .form-label {
            font-weight: bold;
            margin-bottom: 6px;
        }

        .btn-gradient {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 10px;
            width: 100%;
            border-radius: 8px;
            font-size: 16px;
        }

        .btn-gradient:hover {
            opacity: 0.9;
        }

        .row > div {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h3 class="text-center mb-4">Đăng ký tài khoản</h3>
    <form action="register" method="post">
        <div class="row">
            <div class="col-md-6">
                <label class="form-label">Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" required />
            </div>
            <div class="col-md-6">
                <label class="form-label">Họ tên</label>
                <input type="text" name="fullName" class="form-control" value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>" required />
            </div>

            <div class="col-md-6">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" required />
            </div>
            <div class="col-md-6">
                <label class="form-label">Xác nhận mật khẩu</label>
                <input type="password" name="confirmPassword" class="form-control" required />
            </div>

            <div class="col-md-6">
                <label class="form-label">Phòng ban</label>
                <select name="divisionId" class="form-control" required>
                    <option value="">-- Chọn phòng ban --</option>
                    <%
                        List<Division> divisions = (List<Division>) request.getAttribute("divisions");
                        String selectedDiv = request.getParameter("divisionId");
                        if (divisions != null) {
                            for (Division d : divisions) {
                                boolean selected = selectedDiv != null && selectedDiv.equals(String.valueOf(d.getId()));
                    %>
                    <option value="<%= d.getId() %>" <%= selected ? "selected" : "" %>><%= d.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">Vai trò</label>
                <select name="roleId" class="form-control" required>
                    <option value="">-- Chọn vai trò --</option>
                    <%
                        List<Role> roles = (List<Role>) request.getAttribute("roles");
                        Set<Integer> divisionLeaderDivisions = (Set<Integer>) request.getAttribute("divisionsWithLeader");
                        String selectedRole = request.getParameter("roleId");
                        if (roles != null) {
                            for (Role r : roles) {
                                boolean selected = selectedRole != null && selectedRole.equals(String.valueOf(r.getId()));
                                if ("Division Leader".equalsIgnoreCase(r.getName()) && divisionLeaderDivisions != null) {
                    %>
                    <option value="<%= r.getId() %>" disabled>Division Leader (đã có)</option>
                    <%
                                } else {
                    %>
                    <option value="<%= r.getId() %>" <%= selected ? "selected" : "" %>><%= r.getName() %></option>
                    <%
                                }
                            }
                        }
                    %>
                </select>
            </div>

            <div class="col-md-12">
                <label class="form-label">Quản lý trực tiếp (tùy chọn)</label>
                <select name="managerId" class="form-control">
                    <option value="">-- Chọn quản lý --</option>
                    <%
                        List<User> managers = (List<User>) request.getAttribute("managers");
                        Map<Integer, String> managerRoles = (Map<Integer, String>) request.getAttribute("managerRoles");
                        String selectedMgr = request.getParameter("managerId");
                        if (managers != null) {
                            for (User m : managers) {
                                String role = managerRoles.getOrDefault(m.getId(), "Unknown");
                                boolean selected = selectedMgr != null && selectedMgr.equals(String.valueOf(m.getId()));
                    %>
                    <option value="<%= m.getId() %>" <%= selected ? "selected" : "" %>>
                        <%= m.getFullName() %> (<%= m.getRoleName() %> <%= m.getDivisionName() %>)
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
        </div>

        <button type="submit" class="btn btn-gradient mt-2">Đăng ký</button>
    </form>

    <% if (request.getAttribute("success") != null) { %>
    <div class="mt-3 text-success fw-bold"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="mt-2 text-danger fw-bold">❌ <%= request.getAttribute("error") %></div>
    <% } %>

    <div class="text-center mt-3">
        <a href="login" class="text-dark text-decoration-underline">⬅ Quay về đăng nhập</a>
    </div>
</div>

</body>
</html>

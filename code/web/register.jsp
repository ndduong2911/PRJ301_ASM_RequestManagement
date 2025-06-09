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
                font-family: Arial;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .register-form {
                background: #fff;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.1);
                width: 400px;
            }
            .form-control {
                margin-bottom: 15px;
            }
            .btn-primary {
                width: 100%;
            }
        </style>
    </head>
    <body>

        <div class="register-form">
            <h4 class="text-center mb-4">Đăng ký tài khoản</h4>

            <form action="register" method="post">
                <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required />
                <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required />
                <input type="password" name="confirmPassword" class="form-control" placeholder="Xác nhận mật khẩu" required />
                <input type="text" name="fullName" class="form-control" placeholder="Họ tên" required />

                <select name="divisionId" class="form-control" required>
                    <option value="">-- Chọn phòng ban --</option>
                    <%
                        List<Division> divisions = (List<Division>) request.getAttribute("divisions");
                        if (divisions != null) {
                            for (Division d : divisions) {
                    %>
                    <option value="<%= d.getId() %>"><%= d.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>

                <select name="roleId" class="form-control" required>
                    <option value="">-- Chọn vai trò --</option>
                    <%
                        List<Role> roles = (List<Role>) request.getAttribute("roles");
                        Set<Integer> divisionLeaderDivisions = (Set<Integer>) request.getAttribute("divisionsWithLeader");

                        if (roles != null) {
                            for (Role r : roles) {
                                if ("Division Leader".equalsIgnoreCase(r.getName()) && divisionLeaderDivisions != null) {
                    %>
                    <option value="<%= r.getId() %>" disabled>Division Leader (đã có)</option>
                    <%
                                } else {
                    %>
                    <option value="<%= r.getId() %>"><%= r.getName() %></option>
                    <%
                                }
                            }
                        }
                    %>
                </select>

                <select name="managerId" class="form-control">
                    <option value="">-- Quản lý trực tiếp (tùy chọn) --</option>
                    <%
                        List<User> managers = (List<User>) request.getAttribute("managers");
                        Map<Integer, String> managerRoles = (Map<Integer, String>) request.getAttribute("managerRoles");
                        if (managers != null) {
                            for (User m : managers) {
                                String role = managerRoles.getOrDefault(m.getId(), "Unknown");
                    %>
                    <option value="<%= m.getId() %>">
                        <%= m.getFullName() %> (<%= m.getRoleName() %> <%= m.getDivisionName() %>)
                    </option>
                    <%
                            }
                        }
                    %>
                </select>

                <button type="submit" class="btn btn-primary">Đăng ký</button>
            </form>

            <div class="mt-3 text-success"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></div>
            <div class="mt-2 text-danger"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></div>

            <div class="text-center mt-3">
                <a href="login" class="text-black">⬅ Quay về đăng nhập</a>
            </div>
        </div>

    </body>
</html>

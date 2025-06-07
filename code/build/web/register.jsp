<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Division, model.User"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký tài khoản</title>
</head>
<body>
    <h2>Đăng ký người dùng mới</h2>

    <form action="register" method="post">
        Tên đăng nhập: <input type="text" name="username" required /><br/><br/>
        Mật khẩu: <input type="password" name="password" required /><br/><br/>
        Xác nhận mật khẩu: <input type="password" name="confirmPassword" required /><br/><br/>

        Họ tên: <input type="text" name="fullName" required /><br/><br/>

        Phòng ban:
        <select name="divisionId" required>
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
        </select><br/><br/>

        Quản lý trực tiếp:
        <select name="managerId">
            <option value="">-- Không chọn --</option>
            <%
                List<User> managers = (List<User>) request.getAttribute("managers");
                if (managers != null) {
                    for (User m : managers) {
            %>
                <option value="<%= m.getId() %>"><%= m.getFullName() %> (division <%= m.getDivisionId() %>)</option>
            <%
                    }
                }
            %>
        </select><br/><br/>

        <input type="submit" value="Đăng ký"/>
    </form>

    <p style="color:green;"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></p>
    <p style="color:red;"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>
    <p><a href="login">Quay về đăng nhập</a></p>
</body>
</html>

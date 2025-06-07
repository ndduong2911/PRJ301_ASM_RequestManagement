<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập</title>
</head>
<body>
    <h2>Đăng nhập hệ thống</h2>

    <form action="login" method="post">
        Tên đăng nhập: <input type="text" name="username" required /><br/>
        Mật khẩu: <input type="password" name="password" required /><br/>
        <input type="submit" value="Đăng nhập"/>
    </form>

    <%
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <p style="color:red;"> Tài khoản không đúng hoặc chưa tồn tại.</p>
    <%
        }
    %>

    <p>Chưa có tài khoản?</p>
    <form action="register" method="get">
        <input type="submit" value="Đăng ký ngay"/>
    </form>
</body>
</html>

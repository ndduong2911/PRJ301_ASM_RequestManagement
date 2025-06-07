<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập</title>
    <style>
        body {
            background: url('https://source.unsplash.com/1600x900/?nature,water') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.95);
            width: 320px;
            margin: 100px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px #aaa;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        input[type="text"], input[type="password"] {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        input[type="submit"] {
            width: 95%;
            padding: 10px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 15px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .error {
            color: red;
            margin-top: 10px;
        }

        .register-link {
            margin-top: 15px;
            display: block;
            font-size: 13px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Đăng nhập</h2>

    <form action="login" method="post">
        <input type="text" name="username" placeholder="Tên đăng nhập" required />
        <input type="password" name="password" placeholder="Mật khẩu" required />
        <input type="submit" value="Đăng nhập" />
    </form>

    <%
        String error = request.getParameter("error");
        if ("1".equals(error)) {
    %>
        <p class="error">❌ Tên đăng nhập hoặc mật khẩu sai.</p>
    <%
        }
    %>

    <a class="register-link" href="register">Chưa có tài khoản? Đăng ký</a>
</div>

</body>
</html>

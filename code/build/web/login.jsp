<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng nhập</title>
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

            .login-box {
                background: #fff;
                padding: 35px 40px;
                border-radius: 15px;
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
                width: 400px;
            }

            .form-control {
                height: 45px;
                border-radius: 8px;
                margin-bottom: 15px;
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
                opacity: 0.95;
            }

            .text-link {
                text-align: center;
                margin-top: 15px;
            }

            .text-link a {
                color: #333;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <div class="login-box">
            <h4 class="text-center mb-4">Đăng nhập</h4>

            <form action="login" method="post">
                <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required />
                <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required />
                <button type="submit" class="btn-gradient">Đăng nhập</button>
            </form>

            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div class="alert alert-danger text-center mt-3"><%= error %></div>
            <% } %>

            <div class="text-link">
                <a href="register">Chưa có tài khoản? Đăng ký ngay</a>
            </div>
        </div>

    </body>
</html>

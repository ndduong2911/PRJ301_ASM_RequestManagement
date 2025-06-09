<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea, #764ba2);
            background-size: cover;
            font-family: 'Segoe UI', sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
        }
        .login-card {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

<div class="login-card">
    <h3 class="text-center mb-4">Đăng nhập</h3>

    <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ❌ Tên đăng nhập hoặc mật khẩu sai.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <form action="login" method="post">
        <div class="mb-3">
            <input type="text" name="username" class="form-control" placeholder="Tên đăng nhập" required>
        </div>
        <div class="mb-3">
            <input type="password" name="password" class="form-control" placeholder="Mật khẩu" required>
        </div>
        <div class="d-grid">
            <input type="submit" class="btn btn-primary" value="Đăng nhập">
        </div>
    </form>

    <div class="text-center mt-3">
        <a href="register">Chưa có tài khoản? Đăng ký ngay</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
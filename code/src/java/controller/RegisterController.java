package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.util.List;

import dal.UserDAO;
import dal.DivisionDAO;
import dal.UserRoleDAO;
import model.User;
import model.Division;
import util.DBContext;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DBContext.getConnection()) {
            DivisionDAO divisionDAO = new DivisionDAO(conn);
            List<Division> divisions = divisionDAO.getAllDivisions();
            List<User> managers = new UserDAO(conn).getAllManagers();

            req.setAttribute("divisions", divisions);
            req.setAttribute("managers", managers);
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DBContext.getConnection()) {
            String username = req.getParameter("username");
            String rawPassword = req.getParameter("password");
            String confirmPassword = req.getParameter("confirmPassword");
            String fullName = req.getParameter("fullName");
            int divisionId = Integer.parseInt(req.getParameter("divisionId"));
            String mgrStr = req.getParameter("managerId");
            Integer managerId = (mgrStr == null || mgrStr.isEmpty()) ? null : Integer.parseInt(mgrStr);

            UserDAO dao = new UserDAO(conn);

            if (!rawPassword.equals(confirmPassword)) {
                req.setAttribute("error", "❌ Mật khẩu xác nhận không khớp.");
            } else if (dao.getUserByUsername(username) != null) {
                req.setAttribute("error", "⚠️ Tên đăng nhập đã tồn tại.");
            } else {
                String password = hashPassword(rawPassword);
                User user = new User(0, username, password, fullName, divisionId, managerId);
                int userId = dao.registerUserReturnId(user);
                new UserRoleDAO(conn).assignRoleToUser(userId, 3); // Role 3 = Nhân viên
                req.setAttribute("success", "✅ Đăng ký thành công! Bạn có thể đăng nhập.");
            }

            // Gửi lại dữ liệu để reload form
            DivisionDAO divisionDAO = new DivisionDAO(conn);
            req.setAttribute("divisions", divisionDAO.getAllDivisions());
            req.setAttribute("managers", new UserDAO(conn).getAllManagers());
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return password;
        }
    }
}

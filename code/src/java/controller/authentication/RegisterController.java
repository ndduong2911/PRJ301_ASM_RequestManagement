package controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.util.List;

import dal.*;
import model.*;
import util.DBContext;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DBContext.getConnection()) {
            DivisionDAO divisionDAO = new DivisionDAO(conn);
            RoleDAO roleDAO = new RoleDAO(conn);
            UserDAO userDAO = new UserDAO(conn);
            UserRoleDAO userRoleDAO = new UserRoleDAO(conn);

            req.setAttribute("divisions", divisionDAO.getAllDivisions());
            req.setAttribute("roles", roleDAO.getAllRoles());
            List<User> managers = userDAO.getAllManagersWithRoleAndDivision();
            req.setAttribute("managers", managers);

            req.setAttribute("managerRoles", userRoleDAO.getUserRoleNamesMap());

            req.getRequestDispatcher("view/authentication/register.jsp").forward(req, resp); // ✅ updated
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
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            String mgrStr = req.getParameter("managerId");
            Integer managerId = (mgrStr == null || mgrStr.isEmpty()) ? null : Integer.parseInt(mgrStr);

            UserDAO userDAO = new UserDAO(conn);
            RoleDAO roleDAO = new RoleDAO(conn);
// Regex kiểm tra
            boolean invalidUsername = !username.matches("^[a-zA-Z0-9]{8,16}$");
            boolean weakPassword = !rawPassword.matches("^(?=.*[a-z])(?=.*\\d).{10,}$");
            boolean invalidFullName = !fullName.matches("^[\\p{L}]+(\\s[\\p{L}]+)+$");

            if (invalidUsername) {
                req.setAttribute("error", "⚠️ Tên đăng nhập phải dài 8–16 ký tự, không chứa ký tự đặc biệt.");
            } else if (invalidFullName) {
                req.setAttribute("error", "⚠️ Họ tên phải gồm ít nhất 2 từ, chỉ chứa chữ và khoảng trắng.");
            } else if (weakPassword) {
                req.setAttribute("error", "⚠️ Mật khẩu phải có ít nhất 10 ký tự, bao gồm chữ thường và số.");
            } else if (!rawPassword.equals(confirmPassword)) {
                req.setAttribute("error", " Mật khẩu xác nhận không khớp.");
            } else if (userDAO.getUserByUsername(username) != null) {
                req.setAttribute("error", "⚠️ Tên đăng nhập đã tồn tại.");
            } else if (roleDAO.roleNameById(roleId).equalsIgnoreCase("Division Leader")
                    && userDAO.hasDivisionLeader(divisionId)) {
                req.setAttribute("error", " Phòng ban này đã có Division Leader.");
            } else if (managerId != null) {
                User manager = userDAO.getUserById(managerId);
                if (manager == null || manager.getDivisionId() != divisionId) {
                    req.setAttribute("error", " Người quản lý đã chọn không thuộc phòng ban này!");
                } else {
                    String password = hashPassword(rawPassword);
                    User user = new User(0, username, password, fullName, divisionId, managerId);
                    int userId = userDAO.registerUserReturnId(user);
                    new UserRoleDAO(conn).assignRoleToUser(userId, roleId);
                    req.setAttribute("success", "✅ Đăng ký thành công! Bạn có thể đăng nhập.");
                }
            } else {
                String password = hashPassword(rawPassword);
                User user = new User(0, username, password, fullName, divisionId, null);
                int userId = userDAO.registerUserReturnId(user);
                new UserRoleDAO(conn).assignRoleToUser(userId, roleId);
                req.setAttribute("success", "✅ Đăng ký thành công! Bạn có thể đăng nhập.");
            }

            req.setAttribute("divisions", new DivisionDAO(conn).getAllDivisions());
            req.setAttribute("roles", new RoleDAO(conn).getAllRoles());
            req.setAttribute("managers", userDAO.getAllManagersWithRoleAndDivision());
            req.setAttribute("managerRoles", new UserRoleDAO(conn).getUserRoleNamesMap());

            req.setAttribute("username", username);
            req.setAttribute("fullName", fullName);
            req.setAttribute("divisionId", divisionId);
            req.setAttribute("roleId", roleId);
            req.setAttribute("managerId", managerId);
            req.getRequestDispatcher("view/authentication/register.jsp").forward(req, resp); // ✅ updated
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

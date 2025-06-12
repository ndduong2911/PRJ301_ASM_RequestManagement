package controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.util.List;

import dal.UserDAO;
import dal.RoleDAO;
import dal.DivisionDAO;
import model.User;
import model.Role;
import model.Division;
import util.DBContext;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String rawPassword = req.getParameter("password");
        String hashedPassword = hashPassword(rawPassword);

        try (Connection conn = DBContext.getConnection()) {
            UserDAO userDAO = new UserDAO(conn);
            User user = userDAO.getUserByUsername(username);

            if (user != null && user.getPassword().equals(hashedPassword)) {
                DivisionDAO divisionDAO = new DivisionDAO(conn);
                Division division = divisionDAO.getDivisionById(user.getDivisionId());
                if (division != null) {
                    user.setDivisionName(division.getName());
                }

                RoleDAO roleDAO = new RoleDAO(conn);
                List<Role> roles = roleDAO.getRolesByUserId(user.getId());
                if (!roles.isEmpty()) {
                    user.setRoleName(roles.get(0).getName()); // ✅ gán roleName
                }

                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("roles", roles);

                session.setAttribute("success", "✅ Đăng nhập thành công!");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "❌ Tên đăng nhập hoặc mật khẩu không đúng.");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
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

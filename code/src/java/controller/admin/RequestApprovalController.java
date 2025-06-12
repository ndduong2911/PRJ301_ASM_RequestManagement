package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import dal.RequestDAO;
import model.Request;
import model.Role;
import model.User;
import util.DBContext;

@WebServlet("/request/approve")
public class RequestApprovalController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("user");
        List<Role> roles = (List<Role>) req.getSession().getAttribute("roles");

        if (currentUser == null || roles == null) {
            resp.sendRedirect(req.getContextPath() + "/view/authentication/login.jsp"); // ✅ updated
            return;
        }

        boolean isManager = false;
        for (Role r : roles) {
            if ("Division Leader".equalsIgnoreCase(r.getName())) {
                isManager = true;
                break;
            }
        }

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            List<Request> subRequests = dao.getRequestsOfSubordinates(
                    currentUser.getId(),
                    currentUser.getDivisionId(),
                    isManager
            );

            req.getSession().setAttribute("subordinateRequests", subRequests);
            req.getSession().setAttribute("success", req.getAttribute("success"));
            req.getSession().setAttribute("error", req.getAttribute("error"));

            resp.sendRedirect(req.getContextPath() + "/view/index.jsp?feature=approve"); // ✅ updated
        } catch (Exception e) {
            throw new ServletException("Không thể lấy danh sách đơn cấp dưới", e);
        }
    }
}

package controller;

import dal.RequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Request;
import model.User;
import util.DBContext;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/request/process")
public class ProcessRequestController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String note = req.getParameter("note");
        int id = Integer.parseInt(req.getParameter("id"));

        User currentUser = (User) req.getSession().getAttribute("user");

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            boolean updated = false;

            if ("approve".equals(action)) {
                updated = dao.updateRequestStatus(id, "Approved", currentUser.getId(), note);
            } else if ("reject".equals(action)) {
                updated = dao.updateRequestStatus(id, "Rejected", currentUser.getId(), note);
            }

            if (updated) {
                req.getSession().setAttribute("success", "Đã cập nhật trạng thái đơn.");
            } else {
                req.getSession().setAttribute("error", "Không thể cập nhật đơn.");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi xử lý: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/request/approve");
    }
}

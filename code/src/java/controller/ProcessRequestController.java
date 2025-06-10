
package controller;

import dal.RequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import util.DBContext;
import java.sql.*;


@WebServlet("/request/process")
public class ProcessRequestController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int requestId = Integer.parseInt(req.getParameter("requestId"));
        String action = req.getParameter("action");
        int userId = ((User) req.getSession().getAttribute("user")).getId();

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            String status = "approve".equals(action) ? "Approved" : "Rejected";
            dao.updateStatus(requestId, status, userId);
            req.getSession().setAttribute("success", "✔️ Đã " + (status.equals("Approved") ? "duyệt" : "từ chối") + " đơn.");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "❌ Xảy ra lỗi khi xử lý.");
        }
        resp.sendRedirect(req.getContextPath() + "/request/approve");
    }
}
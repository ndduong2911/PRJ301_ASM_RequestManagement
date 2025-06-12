package controller.request;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import dal.RequestDAO;
import util.DBContext;

@WebServlet("/request/delete")
public class DeleteRequestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            dao.deleteRequest(id);
            HttpSession session = req.getSession();
            session.setAttribute("success", "Xóa đơn thành công!");
        } catch (Exception e) {
            HttpSession session = req.getSession();
            session.setAttribute("error", "Xóa đơn thất bại!");
        }

        resp.sendRedirect(req.getContextPath() + "/request/list");
    }
}

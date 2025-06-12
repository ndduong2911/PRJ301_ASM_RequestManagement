package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

import dal.RequestDAO;
import model.Request;
import util.DBContext;

@WebServlet("/reviewRequest")
public class ReviewRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idRaw = req.getParameter("id");
        if (idRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/view/index.jsp?feature=approve"); // ✅ updated
            return;
        }

        try (Connection conn = DBContext.getConnection()) {
            int id = Integer.parseInt(idRaw);
            RequestDAO dao = new RequestDAO(conn);
            Request r = dao.getById(id);
            if (r == null) {
                req.getSession().setAttribute("error", "Không tìm thấy đơn.");
                resp.sendRedirect(req.getContextPath() + "/view/index.jsp?feature=approve"); // ✅ updated
                return;
            }
            req.getSession().setAttribute("reviewRequest", r);
            resp.sendRedirect(req.getContextPath() + "/view/admin/reviewRequest.jsp"); // ✅ updated
        } catch (Exception e) {
            throw new ServletException("Lỗi khi load đơn nghỉ", e);
        }
    }
}

package controller.request;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import dal.RequestDAO;
import model.Request;
import util.DBContext;

@WebServlet("/request/edit")
public class EditRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            Request r = dao.getRequestById(id);
            req.setAttribute("requestToEdit", r);
            req.getRequestDispatcher("/editRequest.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String fromStr = req.getParameter("fromDate");
        String toStr = req.getParameter("toDate");
        String reason = req.getParameter("reason");

        try (Connection conn = DBContext.getConnection()) {
            Date fromDate = Date.valueOf(fromStr);
            Date toDate = Date.valueOf(toStr);
            Date today = new Date(System.currentTimeMillis());

            if (fromDate.before(today) || toDate.before(fromDate)) {
                HttpSession session = req.getSession();
                session.setAttribute("error", "Ngày không hợp lệ!");
                Request temp = new Request();
                temp.setId(id);
                temp.setFromDate(fromDate);
                temp.setToDate(toDate);
                temp.setReason(reason);
                req.setAttribute("requestToEdit", temp);
                resp.sendRedirect(req.getContextPath() + "/request/edit?id=" + id);
                return;
            }

            RequestDAO dao = new RequestDAO(conn);
            dao.updateRequest(id, fromDate, toDate, reason);

            HttpSession session = req.getSession();
            session.setAttribute("success", "Cập nhật thành công!");
            resp.sendRedirect(req.getContextPath() + "/request/edit?id=" + id);

        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Định dạng ngày không hợp lệ!");
            req.getRequestDispatcher("/editRequest.jsp").forward(req, resp);
        } catch (Exception e) {
            HttpSession session = req.getSession();
            session.setAttribute("error", "Cập nhật thất bại hoặc không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/request/edit?id=" + id);
        }
    }
}
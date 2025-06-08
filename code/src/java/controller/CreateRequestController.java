package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import dal.RequestDAO;
import model.Request;
import model.User;
import util.DBContext;

@WebServlet("/request/create")
public class CreateRequestController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String fromStr = req.getParameter("fromDate");
        String toStr = req.getParameter("toDate");
        String reason = req.getParameter("reason");

        try (Connection conn = DBContext.getConnection()) {
            Date fromDate = Date.valueOf(fromStr);
            Date toDate = Date.valueOf(toStr);
            Date today = new Date(System.currentTimeMillis());

            if (fromDate.before(today) || toDate.before(fromDate)) {
                session.setAttribute("error", "Ngày không hợp lệ!");
                resp.sendRedirect(req.getContextPath() + "/index.jsp?feature=create");
                return;
            }

            RequestDAO dao = new RequestDAO(conn);
            if (dao.hasOverlappingRequest(user.getId(), fromDate, toDate)) {
                session.setAttribute("error", "Bạn đã có đơn nghỉ trong khoảng thời gian này!");
                resp.sendRedirect(req.getContextPath() + "/index.jsp?feature=create");
                return;
            }

            Request r = new Request();
            r.setTitle("Đơn nghỉ phép");
            r.setFromDate(fromDate);
            r.setToDate(toDate);
            r.setReason(reason);
            r.setStatus("Inprogress");
            r.setCreatedBy(user.getId());

            dao.createRequest(r);
            session.setAttribute("success", "Đơn đã gửi thành công!");
            resp.sendRedirect(req.getContextPath() + "/index.jsp?feature=create");

        } catch (IllegalArgumentException e) {
            session.setAttribute("error", "Định dạng ngày không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/index.jsp?feature=create");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/index.jsp?feature=create");
    }
}

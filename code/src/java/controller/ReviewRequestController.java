package controller;

import dal.RequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import dal.UserDAO;
import model.Request;
import model.User;
import util.DBContext;

@WebServlet("/request/review")
public class ReviewRequestController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            Request r = dao.getRequestById(id);
            req.setAttribute("request", r);
            req.getRequestDispatcher("/reviewRequest.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String action = req.getParameter("action");
        String note = req.getParameter("note");
        User currentUser = (User) req.getSession().getAttribute("user");

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            String status = "Rejected".equals(action) ? "Rejected" : "Approved";
            dao.updateStatus(id, status, note, currentUser.getId());
            resp.sendRedirect("requestList?success=1");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

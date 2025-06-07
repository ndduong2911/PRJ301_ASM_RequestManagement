package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

import dal.RequestDAO;
import model.Request;
import model.User;
import util.DBContext;

@WebServlet("/request/edit")
public class EditRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int requestId = Integer.parseInt(req.getParameter("id"));
        User user = (User) req.getSession().getAttribute("user");

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            Request request = dao.getRequestById(requestId);

            if (request != null && request.getCreatedBy() == user.getId() && "Inprogress".equals(request.getStatus())) {
                req.setAttribute("request", request);
                req.getRequestDispatcher("/editRequest.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("request/list");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            int id = Integer.parseInt(req.getParameter("id"));
            Request old = dao.getRequestById(id);

            if (old != null && old.getCreatedBy() == user.getId() && "Inprogress".equals(old.getStatus())) {
                old.setTitle(req.getParameter("title"));
                old.setFromDate(java.sql.Date.valueOf(req.getParameter("fromDate")));
                old.setToDate(java.sql.Date.valueOf(req.getParameter("toDate")));
                old.setReason(req.getParameter("reason"));
                dao.updateRequest(old);
            }

            resp.sendRedirect("list");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

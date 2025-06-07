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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect("login.jsp"); return; }

        try (Connection conn = DBContext.getConnection()) {
            Request request = new Request();
            request.setTitle("Đơn nghỉ phép");
            request.setFromDate(Date.valueOf(req.getParameter("fromDate")));
            request.setToDate(Date.valueOf(req.getParameter("toDate")));
            request.setReason(req.getParameter("reason"));
            request.setStatus("Inprogress");
            request.setCreatedBy(user.getId());

            new RequestDAO(conn).createRequest(request);
            resp.sendRedirect("requestList.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
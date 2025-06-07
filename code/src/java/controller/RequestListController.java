package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import dal.RequestDAO;
import model.Request;
import model.User;
import util.DBContext;

@WebServlet("/request/list")
public class RequestListController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) { resp.sendRedirect("login.jsp"); return; }

        try (Connection conn = DBContext.getConnection()) {
            List<Request> requests = new RequestDAO(conn).getRequestsByUser(user.getId());
            req.setAttribute("requests", requests);
            req.getRequestDispatcher("requestList.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

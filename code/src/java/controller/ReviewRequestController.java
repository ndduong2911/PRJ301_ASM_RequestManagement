package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import dal.UserDAO;
import model.User;
import util.DBContext;

@WebServlet("/request/review")
public class ReviewRequestController extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User reviewer = (User) req.getSession().getAttribute("user");
        if (reviewer == null) { resp.sendRedirect("login.jsp"); return; }

        try (Connection conn = DBContext.getConnection()) {
            int requestId = Integer.parseInt(req.getParameter("requestId"));
            String action = req.getParameter("action");
            String note = req.getParameter("note");

            String sql = "UPDATE Requests SET status = ?, processed_by = ?, processed_note = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, action.equals("approve") ? "Approved" : "Rejected");
            ps.setInt(2, reviewer.getId());
            ps.setString(3, note);
            ps.setInt(4, requestId);
            ps.executeUpdate();

            resp.sendRedirect("requestList.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

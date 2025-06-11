package controller;

import dal.RequestDAO;
import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import util.DBContext; 
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.sql.Connection;

@WebServlet("/agenda")
public class AgendaController extends HttpServlet {

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    User currentUser = (User) req.getSession().getAttribute("user");
    if (currentUser == null) {
        resp.sendRedirect("login.jsp");
        return;
    }

    String fromStr = req.getParameter("from");
    String toStr   = req.getParameter("to");

    if (fromStr == null || toStr == null) {
        req.setAttribute("feature", "agenda");
        req.getRequestDispatcher("index.jsp").forward(req, resp);
        return;
    }

    LocalDate from = LocalDate.parse(fromStr);
    LocalDate to   = LocalDate.parse(toStr);

    try (Connection conn = DBContext.getConnection()) {

        UserDAO userDAO       = new UserDAO(conn);     // ✅ truyền conn
        RequestDAO requestDAO = new RequestDAO(conn);  // ✅ truyền conn

        List<User> userList = userDAO.getUsersByDivision(currentUser.getDivisionId());
        Map<Integer, Set<String>> leaveMap =
                requestDAO.getLeaveDaysByDivision(currentUser.getDivisionId(), from, to);

        /* ngày trong khoảng */
        List<String> dateList = new ArrayList<>();
        for (LocalDate d = from; !d.isAfter(to); d = d.plusDays(1)) {
            dateList.add(d.toString());
        }

        req.setAttribute("userList",  userList);
        req.setAttribute("dateList",  dateList);
        req.setAttribute("leaveMap",  leaveMap);
        req.setAttribute("feature",   "agenda");
        req.getRequestDispatcher("index.jsp").forward(req, resp);

    } catch (Exception e) {
        throw new ServletException(e);
    }
}
}

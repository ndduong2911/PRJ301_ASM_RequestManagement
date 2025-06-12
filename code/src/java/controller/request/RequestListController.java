package controller.request;

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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try (Connection conn = DBContext.getConnection()) {
            RequestDAO dao = new RequestDAO(conn);
            List<Request> list = dao.getRequestsByUser(user.getId());
            session.setAttribute("myRequests", list);

            // ✅ Lấy thông báo thành công/thất bại nếu có
            String success = (String) session.getAttribute("success");
            String error = (String) session.getAttribute("error");
            if (success != null) {
                req.setAttribute("success", success);
                session.removeAttribute("success");
            }
            if (error != null) {
                req.setAttribute("error", error);
                session.removeAttribute("error");
            }

            req.getRequestDispatcher("/index.jsp?feature=list").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
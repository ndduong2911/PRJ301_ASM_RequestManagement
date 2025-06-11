<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Role, model.Request, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    Request requestData = (Request) session.getAttribute("reviewRequest");
    List<Role> roles = (List<Role>) session.getAttribute("roles");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String activeFeature = request.getParameter("feature");

    String success = (String) session.getAttribute("success");
    String error = (String) session.getAttribute("error");
    session.removeAttribute("success");
    session.removeAttribute("error");

    List<Request> myRequests = (List<Request>) session.getAttribute("myRequests");
    session.removeAttribute("myRequests");
    
    
    List<Request> subordinateRequests = (List<Request>) session.getAttribute("subordinateRequests");
    session.removeAttribute("subordinateRequests");

    boolean isLeader = false;
    boolean isManager = false;
    for (Role r : roles) {
        if ("Trưởng nhóm".equalsIgnoreCase(r.getName())) isLeader = true;
        if ("Division Leader".equalsIgnoreCase(r.getName())) isManager = true;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Trang chính - Request System</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
        <style>
            body {
                font-family: Arial;
            }
            .sidebar {
                height: 100vh;
                background-color: #007bff;
                color: white;
                padding: 20px;
            }
            .sidebar a {
                color: white;
                text-decoration: none;
                display: block;
                padding: 8px 10px;
                border-radius: 4px;
            }
            .sidebar a.active {
                background-color: aqua;
                color: black;
            }
            .content {
                padding: 30px;
            }
        </style>
    </head>
    <body class="d-flex">

        <!-- Sidebar -->
        <div class="sidebar">
            <h5>👤 <%= user.getFullName() %></h5>
            <hr/>
            <p><strong>Vai trò:</strong></p>
            <ul>
                <% for (Role r : roles) { %>
                <li><%= r.getName() %></li>
                    <% } %>
            </ul>
            <hr/>
            <a href="<%= request.getContextPath() %>/index.jsp?feature=create" class="<%= "create".equals(activeFeature) ? "active" : "" %>">📝 Tạo đơn nghỉ phép</a>
            <a href="<%= request.getContextPath() %>/request/list" class="<%= "list".equals(activeFeature) ? "active" : "" %>">📄 Xem đơn của tôi</a>

            <% if (isLeader || isManager) { %>
            <a href="<%= request.getContextPath() %>/request/approve" class="<%= "approve".equals(activeFeature) ? "active" : "" %>">📥 Xét duyệt đơn cấp dưới</a>

            <% } %>

            <% if (isManager) { %>
            <a href="agenda" class="<%= "agenda".equals(activeFeature) ? "active" : "" %>">📊 Agenda phòng</a>
            <% } %>
        </div>

        <!-- Content -->
        <div class="flex-grow-1">
            <nav class="d-flex justify-content-end p-3">
                <form action="<%= request.getContextPath() %>/logout" method="post">
                    <button class="btn btn-outline-danger btn-sm">Đăng xuất</button>
                </form>
            </nav>

            <div class="container content">

                <% if ("list".equals(activeFeature)) { %>
                <h3>Danh sách đơn nghỉ phép</h3>
                <% if (myRequests == null || myRequests.isEmpty()) { %>
                <div class="alert alert-info">Bạn chưa có đơn nghỉ phép nào.</div>
                <% } else { %>
                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>Tiêu đề</th>
                            <th>Từ ngày</th>
                            <th>Đến ngày</th>
                            <th>Lý do</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú xử lý</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Request r : myRequests) { %>
                        <tr>
                            <td><%= r.getTitle() %></td>
                            <td><%= r.getFromDate() %></td>
                            <td><%= r.getToDate() %></td>
                            <td><%= r.getReason() %></td>
                            <td>
                                <% String status = r.getStatus(); %>
                                <% if ("Inprogress".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-warning text-dark">Inprogress</span>
                                <a href="<%= request.getContextPath() + "/request/edit?id=" + r.getId() %>" class="btn btn-sm btn-warning ms-2">Sửa</a>
                                <% } else if ("Approved".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-success">Approved</span>
                                <% } else if ("Rejected".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-danger">Rejected</span>
                                <% } else { %>
                                <span class="badge bg-secondary"><%= status %></span>
                                <% } %>
                            </td>
                            <td><%= r.getProcessedNote() != null ? r.getProcessedNote() : "Chưa có" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>



                <% } else if ("approve".equals(activeFeature)) { %>
                <h3>Danh sách các đơn xin nghỉ của cấp dưới </h3>
                <% if (subordinateRequests == null || subordinateRequests.isEmpty()) { %>
                <div class="alert alert-info">Không có đơn nào cần xét duyệt.</div>
                <% } else { %>
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>Tiêu đề</th>
                            <th>Từ ngày</th>
                            <th>Đến ngày</th>
                            <th>Người tạo</th>
                            <th>Phòng ban</th>
                            <th>Trạng thái</th>
                            <th>Được duyệt bởi</th>
                           
                            
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Request r : subordinateRequests) { %>
                        <tr>
                            <td>
                                <a href="reviewRequest?id=<%= r.getId() %>"><%= r.getReason() %></a>
                            </td>
                            <td><%= r.getFromDate() %></td>
                            <td><%= r.getToDate() %></td>
                            <td><%= r.getCreatorName() %></td>
                            <td><%= r.getDivisionName() %></td>
                            
                            <td>
                                <% String status = r.getStatus(); %>
                                <% if ("Inprogress".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-warning text-dark">Inprogress</span>
                                <% } else if ("Approved".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-success">Approved</span>
                                <% } else if ("Rejected".equalsIgnoreCase(status)) { %>
                                <span class="badge bg-danger">Rejected</span>
                                <% } else { %>
                                <span class="badge bg-secondary"><%= status %></span>
                                <% } %>
                            </td>
                            <td>
                                <%= r.getProcessedByName() != null ? r.getProcessedByName() : "Chưa xử lý" %>
                            </td>
                          

                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>

                <% } else { %>
                <!-- Tạo đơn nghỉ -->
                <div class="card shadow">
                    <div class="card-header bg-primary text-white text-center">
                        <h4>Tạo đơn xin nghỉ phép</h4>
                    </div>
                    <div class="text-black small mt-2 text-center">
                        User: <%= user.getFullName() %>, 
                        Role: <%= roles.size() > 0 ? roles.get(0).getName() : "Không rõ" %>, 
                        Dep: <%= user.getDivisionName() != null ? user.getDivisionName() : "Không rõ" %>
                    </div>
                    <div class="card-body">
                        <% if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } else if (success != null) { %>
                        <div class="alert alert-success"><%= success %></div>
                        <% } %>

                        <form action="request/create" method="post">
                            <div class="mb-3">
                                <label for="fromDate" class="form-label">Từ ngày:</label>
                                <input type="date" class="form-control" id="fromDate" name="fromDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="toDate" class="form-label">Đến ngày:</label>
                                <input type="date" class="form-control" id="toDate" name="toDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="reason" class="form-label">Lý do:</label>
                                <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Gửi đơn</button>
                        </form>
                    </div>
                    <div class="card-footer text-center text-muted">
                        Hệ thống quản lý đơn nghỉ phép
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Toast -->
        <% if ("list".equals(activeFeature)) { %>
        <% if (success != null) { %>
        <div class="alert alert-success alert-dismissible fade show position-fixed top-0 end-0 m-4 shadow" role="alert" style="z-index: 9999;">
            ✅ <strong><%= success %></strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } else if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show position-fixed top-0 end-0 m-4 shadow" role="alert" style="z-index: 9999;">
            ❌ <strong><%= error %></strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>
        <% } %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
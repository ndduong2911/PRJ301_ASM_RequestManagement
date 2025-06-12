
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Role, model.Request, java.util.List, java.util.Map, java.util.Set" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
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
            /* ===== Layout chung ===== */
            body{
                font-family: Arial, sans-serif;
                background:#f5f6fa;
            }
            .content{
                padding:30px
            }

            /* ===== Sidebar ===== */
            .sidebar{
                height:100vh;
                background:linear-gradient(to bottom right,#ea44d3,#5aaeff); /* tím-xanh trung bình */
                color:#fff;
                padding:20px
            }
            .sidebar a{
                color:#fff;
                text-decoration:none;
                display:block;
                padding:8px 12px;
                border-radius:6px;
                transition:background-color .3s ease
            }
            .sidebar a.active{
                background:linear-gradient(to right,#f3b0e0,#b3daff);      /* pastel sáng hơn */
                color: black;
                font-weight:bold
            }

            /* ===== Card Tạo đơn ===== */
            .card-header{
                background:linear-gradient(to right,#ea44d3,#5aaeff);
                color:#fff;
                font-weight:bold;
                font-size:18px;
                padding:12px 20px;
                border-top-left-radius:.75rem;
                border-top-right-radius:.75rem
            }
            .card-footer{
                text-align:center;
                font-style:italic;
                color:#666
            }

            /* ===== Form control & nút ===== */
            .form-control{
                height:45px;
                border-radius:10px;
                background:#fff;
                border:1px solid #ccc;
                box-shadow:inset 0 1px 2px rgba(0,0,0,.05);
                margin-bottom:12px
            }
            .btn-success{
                background:linear-gradient(to right,#56ab2f,#a8e063);
                font-weight:bold;
                border:none;
                color:#fff
            }
            .btn-success:hover{
                opacity:.9
            }

            /* ===== Bảng Agenda ===== */
            .staff-col{
                min-width:160px;
                max-width:260px;
                white-space:nowrap
            }
            th.date-col,td.date-col{
                white-space:nowrap;
                text-align:center;
                vertical-align:middle;
                min-width:100px;
                border-radius:6px;
                border:1px solid #dee2e6
            }
            .table-hover tbody tr:hover td{
                background:#f1f1f1
            }
            .table thead th{
                background:#343a40;
                color:#fff;
                text-align:center
            }

            .btn-gradient {
                background: linear-gradient(to right, #6a11cb, #2575fc);
                color: white;
                font-weight: bold;
                border: none;
                border-radius: 8px;
                transition: 0.3s ease;
            }

        </style>
    </head>
    <body class="d-flex">
        <% if (success != null) { %>
        <div class="alert alert-success text-center" style="
             position: fixed;
             top: 10px;
             left: 58.5%;
             transform: translateX(-50%);
             z-index: 9999;
             padding: 10px 20px;
             border-radius: 8px;
             background: linear-gradient(to right, #56ab2f, #a8e063);
             color: white;
             font-weight: bold;
             box-shadow: 0 4px 12px rgba(0,0,0,0.2);
             ">
            <%= success %>
        </div>
        <% } %>
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

            <% if (isManager || isLeader) { %>
            <a href="index.jsp?feature=agenda"
               class="<%= "agenda".equals(activeFeature) ? "active" : "" %>">
                📊 Tình hình lao động
            </a>
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
                            <%
    DateTimeFormatter df = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                            %>
                            <td><%= LocalDate.parse(r.getFromDate().toString()).format(df) %></td>
                            <td><%= LocalDate.parse(r.getToDate().toString()).format(df) %></td>
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
                <%
        
        if (success != null) {
                %>
                <div id="alertBox" style="position: fixed; top: 20px; left: 50%; transform: translateX(-50%);
                     background-color: #dff0d8; color: #3c763d; padding: 10px 20px;
                     border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); z-index: 1000;">
                    <% if ("approved".equals(success)) { %>
                    <%= success %>
                    <% } else if ("rejected".equals(success)) { %>
                    <%= success %>
                    <% } %>
                </div>
                <script>
                    setTimeout(() => {
                        const alert = document.getElementById("alertBox");
                        if (alert)
                            alert.remove();
                    }, 1500);
                </script>
                <%
                    }
                %>
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
                            <td><a href="reviewRequest?id=<%= r.getId() %>"><%= r.getReason() %></a></td>
                                <%
        DateTimeFormatter df = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                                %>
                            <td><%= LocalDate.parse(r.getFromDate().toString()).format(df) %></td>
                            <td><%= LocalDate.parse(r.getToDate().toString()).format(df) %></td>
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
                            <td><%= r.getProcessedByName() != null ? r.getProcessedByName() : "Chưa xử lý" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } %>

                <% } else if ("agenda".equals(activeFeature)) { %>
                <h3 class="text-center mb-4">📊 Agenda - Tình hình lao động</h3>
                <div class="card shadow p-4" style="max-width: 600px; margin: auto;">
                    <form method="get" action="agenda" class="row g-3 justify-content-center">
                        <input type="hidden" name="feature" value="agenda" />

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Từ ngày:</label>
                            <input type="date" name="from" class="form-control" required />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Đến ngày:</label>
                            <input type="date" name="to" class="form-control" required />
                        </div>

                        <div class="col-12 text-center mt-3">
                            <button type="submit" class="btn btn-gradient px-4 py-2">Xem tình hình</button>
                        </div>
                    </form>
                </div>

                <%
                    List<model.User> userList = (List<model.User>) request.getAttribute("userList");
                    List<String> dateList = (List<String>) request.getAttribute("dateList");
                    Map<Integer, Set<String>> leaveMap = (Map<Integer, Set<String>>) request.getAttribute("leaveMap");

                    if (userList != null && !userList.isEmpty()) {
                %>
                <div class="table-responsive mt-3">
                    <table class="table table-bordered">
                        <%
    DateTimeFormatter outputFormat = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                        %>
                        <thead>
                            <tr>
                                <th class="staff-col">Nhân sự</th>
                                    <% for (String date : dateList) {
                                        LocalDate d = LocalDate.parse(date);
                                    %>
                                <th class ="date-col"><%= d.format(outputFormat) %></th>
                                    <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (model.User u : userList) {
                                Set<String> leaveDates = leaveMap.getOrDefault(u.getId(), java.util.Collections.emptySet());
                            %>
                            <tr>
                                <td class="staff-col"><%= u.getFullName() %></td>
                                <% for (String date : dateList) { %>
                                <td class ="date-col" style="background-color: <%= leaveDates.contains(date) ? "tomato" : "lightgreen" %>"></td>
                                <% } %>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else if (dateList != null) { %>
                <div class="alert alert-info mt-3">Không có nhân sự nào trong phòng hoặc không có dữ liệu nghỉ phép.</div>
                <% } %>

                <% } else { %>
                <!-- Tạo đơn nghỉ phép -->
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>


    <script>
            setTimeout(() => {
                const alert = document.querySelector('.alert-success');
                if (alert)
                    alert.style.display = 'none';
            }, 3000);
    </script>


</html>

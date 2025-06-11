<%@ page import="java.util.*, model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    List<String> dateList = (List<String>) request.getAttribute("dateList");
    Map<Integer, Set<String>> leaveMap = (Map<Integer, Set<String>>) request.getAttribute("leaveMap");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Agenda - Tình hình lao động</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid gray;
            padding: 5px;
            text-align: center;
        }
        .working { background-color: lightgreen; }
        .leave   { background-color: tomato; }
    </style>
</head>
<body>
    <h2>Agenda - Tình hình lao động</h2>

    <form method="get" action="agenda">
        Từ ngày: <input type="date" name="from" required>
        Đến ngày: <input type="date" name="to" required>
        <input type="submit" value="Xem tình hình">
    </form>

    <%
        if (userList != null && !userList.isEmpty()) {
    %>
    <table>
        <tr>
            <th>Nhân sự</th>
            <% for (String date : dateList) { %>
                <th><%= date %></th>
            <% } %>
        </tr>
        <% for (User u : userList) { %>
        <tr>
            <td><%= u.getFullName() %></td>
            <% 
                Set<String> leaveDates = leaveMap.getOrDefault(u.getId(), Collections.emptySet());
                for (String date : dateList) {
                    String css = leaveDates.contains(date) ? "leave" : "working";
            %>
                <td class="<%= css %>"></td>
            <% } %>
        </tr>
        <% } %>
    </table>
    <% } %>
</body>
</html>

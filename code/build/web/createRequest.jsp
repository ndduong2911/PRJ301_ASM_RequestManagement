<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Tạo đơn xin nghỉ phép</title></head>
<body>
  <h2>Tạo đơn xin nghỉ phép</h2>
  <form action="createRequest" method="post">
    Từ ngày: <input type="date" name="fromDate">
    Đến ngày: <input type="date" name="toDate">
    Lý do: <textarea name="reason" rows="4"></textarea>
    <button type="submit">Gửi đơn</button>
  </form>
</body>
</html>
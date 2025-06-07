<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Xét duyệt đơn</title></head>
<body>
  <h2>Xét duyệt đơn xin nghỉ</h2>
  <form action="reviewRequest" method="post">
    <p>Người tạo: <strong></strong></p>
    Từ ngày: <input type="date" name="fromDate">
    Đến ngày: <input type="date" name="toDate">
    Lý do: <textarea name="reason" rows="4"></textarea>
    <button type="submit" name="action" value="approve">Approve</button>
    <button type="submit" name="action" value="reject">Reject</button>
  </form>
</body>
</html>
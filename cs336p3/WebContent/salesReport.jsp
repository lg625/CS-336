<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sales Report</title>
</head>
<body>
<form action="report.jsp" method="post">
<table align ="center" height="150" >
  <tr>
    <td><h3 style="">Sales Report per Month</h3><td>
  </tr>
  <tr>
    <td>Month:</td>
    <td><input type="number" placeholder="Enter Month you wish to look up in 2 digit form" name="Month"></td>
  </tr>
  <tr>
      <td>Year:</td>
      <td><input type="number" placeholder="Enter the Year you wish to look up in 4 digit form" name="Year"></td>
  </tr>
  <tr align="center">
    <td colspan ="2">
      <input type="submit" value="Submit">
    </td>
  </tr>

</table>
</form>
<br>
<br>
<h4>Previous Page</h4>
	<a href="landing.jsp">Go Back</a>
</body>
</html>
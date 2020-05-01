<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>login</title>
</head>
<p><font size ="20">Train Reservation System</font></p>
<body>
<h1>Per Train Number</h1>
	<form action="trainNumber.jsp" method="post">
<input type="number" placeholder="Enter Train Number " name="trainNum">
<input type="submit" value="Send">

</form>
<br>
<h1>Per Transit Line</h1>
<form action="transitLineName.jsp" method="post">
<input type="text" placeholder="Enter Transit Line " name="tranLine">
<input type="submit" value="Send">

</form>
<br>
<h1>Per Customer Username</h1>
<form action="customerUsername.jsp" method="post">
<input type="text" placeholder="Enter Customer Username " name="cusUser">
<input type="submit" value="Send">
</form>
<br>
<br>
<h4>Previous Page</h4>
	<a href="landing.jsp">Go Back</a>
</html>
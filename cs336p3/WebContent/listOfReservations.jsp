<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>List of Reservations</title>
</head>
<body>
<h1>Train Number</h1>
	<form action="reservationByTrainNumber.jsp" method="post">
<input type="number" placeholder="Enter Train Number " name="TrainNumb">
<input type="submit" value="Send">
</form>
<br>
<h1>Transit Line</h1>
<form action="reservationByTransitLine.jsp" method="post">
<input type="text" placeholder="Enter Train Line " name="TrainLine">
<input type="submit" value="Send">
</form>
<br>
<h1>Customer Name</h1>
<form action="reservationByName.jsp" method="post">
<input type="text" placeholder="Enter Customer Name " name="CustName">
<input type="submit" value="Send">
</form>
<br>
<br>
<h4>Previous Page</h4>
	<a href="landing.jsp">Go Back</a>
</body>
</html>
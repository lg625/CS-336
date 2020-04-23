<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String makeReservation = request.getParameter("make_res");
	String viewReservations = request.getParameter("view_res");
	
	if (makeReservation != null) {
    	response.sendRedirect("reservation.jsp");
	} else if (viewReservations != null){
		out.println("View reservations!");
	} 	
%>

</body>
</html>
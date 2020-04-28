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

	String viewMessages = request.getParameter("view_mess");
	if (makeReservation != null) {
    	response.sendRedirect("reservation.jsp");
	} else if (viewReservations != null){
	    response.sendRedirect("reservationList.jsp");
	} else if (viewMessages != null){
		response.sendRedirect("messenger/messageIndex.jsp");
	}
%>

</body>
</html>
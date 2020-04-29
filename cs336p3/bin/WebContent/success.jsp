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
    if ((session.getAttribute("BaseUser") == null)) {
%>
You are not logged in<br/>
<a href="index.jsp">Please Login</a>
<%} else {
%>
Welcome <%=session.getAttribute("BaseUser")%>  <!--this will display the username that is stored in the session.-->
<a href='logout.jsp'>Log out</a>
<%
    }
%>

<p> <a href="empRedirect.jsp"> Employee Panel</a> </p>

<p> <a href="adminRedirect.jsp"> Admin Panel</a> </p>

</body>
</html>
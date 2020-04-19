<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ page import="java.sql.*"%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
    Statement st = con.createStatement();
    ResultSet rs;

    if ((session.getAttribute("BaseUser") == null)) {
%>
You are not logged in<br/>
<a href="index.jsp">Please Login</a>
<%} else {
	String userName = (String) session.getAttribute("BaseUser");
	String query = "SELECT * FROM Customer WHERE username='" + userName + "'";
	rs = st.executeQuery(query);
   	if (!(rs.next())) {
   		out.println("Not Customer");
   	} else {
   		out.println("Status: Customer");//If account does not exist
   	}

%>
<!--  Check for status here (employee, customer service rep, admin etc) -->
Welcome <%=userName%>  <!--this will display the username that is stored in the session.-->
<a href='logout.jsp'>Log out</a>
<%
    }
%>
</body>
</html>
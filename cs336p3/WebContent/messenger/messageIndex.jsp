<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Message</title>
</head>
<h2> Message Center </h2>
<body>
Welcome <%=session.getAttribute("BaseUser")%> <br>
<%@ page import="java.sql.*"%>
<% 
String userid = request.getParameter("username"); 

Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
Statement st = con.createStatement();
ResultSet rs;
rs = st.executeQuery("SELECT * FROM BaseUser WHERE username='" + userid + "'");
if (rs.next()) {
	out.println("Welcome " + userid);
}
%>
You have 0 currently delayed reservations: <br>
<a href="messageBrowser.jsp">Search/Browse Messages</a> <br>
<a href="messageSender.jsp">Send a Message</a> <br>
<a href="../landing.jsp">Back</a> <br>
</body>
</html>
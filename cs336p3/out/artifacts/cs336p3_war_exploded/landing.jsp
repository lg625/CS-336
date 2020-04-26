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
%>
Welcome <%=userName%>  <!--this will display the username that is stored in the session.-->
<a href='logout.jsp'>Log out</a>


<%
	if (!(rs.next())) {
	    String admQuery = "SELECT * FROM Administrator WHERE admUsername='" + userName + "'";
	    rs = st.executeQuery(admQuery);
	    if (!(rs.next())) {
	        String empQuery = "SELECT * FROM Employee WHERE empUsername='" + userName + "'";
	    	rs = st.executeQuery(empQuery);
	    	if (!(rs.next())) {%>
				You do not have an associated role, please contact the administrator<br/>
				<a href="index.jsp">Go back to login</a>
<%
			} else {
	    	    out.println("Status: Employee");
			}
		} else {
			out.println("Status: Admin");
		}
	} else {%>
<form class="ui large form" action="customerRedirect.jsp" method="POST">
	<input type="submit" value="Make a Reservation" name="make_res"/>
	<input type="submit" value="View Reservations" name="view_res"/>
	<input type="submit" value="Go to Message Center" name="view_mess"/>
</form>
<%out.println("Status: Customer");

}

}
%>
</body>
</html>
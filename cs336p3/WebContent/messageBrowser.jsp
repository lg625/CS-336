<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Message</title>
</head>
<h2> Message Browser </h2>
<body>
<form action="messageSearch.jsp" method="POST">
Search Messages: <input type="text" name="search"/> <br/>
<input type="submit" value="Search" name="s1"/>
</form>
<br>
<%@ page import="java.sql.*,java.util.ArrayList"%>
	<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
	Statement st = con.createStatement();
	ResultSet rs;
	rs = st.executeQuery("SELECT * FROM Messages");
	ArrayList<String> messageText = new ArrayList<String>();
	ArrayList<Boolean> isResolved = new ArrayList<Boolean>();
	ArrayList<String> messageID = new ArrayList<String>();
	ArrayList<String> sentBy = new ArrayList<String>();
	while (rs.next()) {
		messageText.add(rs.getString("msgText"));
		isResolved.add(rs.getBoolean("isResolved"));
		messageID.add(rs.getString("messageID"));
		sentBy.add(rs.getString("sentBy"));
	}
	for (int i = 0; i<messageText.size(); i++) {
		out.println("Message ID: "+messageID.get(i)+"<br>");
		out.println("Sender: "+sentBy.get(i)+"<br>");
		out.println("Message text: "+messageText.get(i)+"<br>");
		if (isResolved.get(i) == true) {
			out.println("Resolved: True <br>");
		} else {
			out.println("Resolved: False <br>");
		}
		out.println("<br>");
	}
	%>
<a href="messageIndex.jsp">Back</a>
</body>
</html>
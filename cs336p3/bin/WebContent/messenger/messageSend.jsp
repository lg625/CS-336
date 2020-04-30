<!DOCTYPE html>
<html>
<head>
<title>messageSend</title>
</head>
<body>
	<%@ page import="java.sql.*"%>
	<%
	String body = request.getParameter("message");
	out.println(body+"<br>");
	if (body.isEmpty()) {
		out.println("Please input a message body.");
	} else {
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
		String insert = "INSERT INTO Messages(msgText, isResolved, messageID, sentBy)" + "VALUES (?, ?, ?, ?)";
		String user = session.getAttribute("BaseUser").toString();
    	PreparedStatement ps = con.prepareStatement(insert);
    	Statement st = con.createStatement();
    	ResultSet rs;
    	rs = st.executeQuery("SELECT * FROM Messages");
    	int count = 1;
    	while (rs.next()) {
    		count++;
    	}
    		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
    		ps.setString(1, body);
    		ps.setBoolean(2, false);
    		ps.setInt(3, count);
    		ps.setString(4, user);
    	//Run the query against the DB
    	ps.executeUpdate();
    	con.close();
    	out.println("Message sent. <br>");
	}
	%>
	<br>
	<a href="messageIndex.jsp">Back</a>
</body>
</html>

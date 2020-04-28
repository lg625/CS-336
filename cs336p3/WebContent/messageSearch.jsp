<html>
<head>
<meta charset="UTF-8">
<title>Message Search</title>
</head>
<h2> Search Results </h2>
<body>
<%@ page import="java.sql.*,java.util.ArrayList"%>
	<%
	String searchParam = request.getParameter("search");
	
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
	boolean oneMessage=false;
	for (int i = 0; i<messageText.size(); i++) {
		if (messageText.get(i).toLowerCase().contains(searchParam.toLowerCase())) {
			out.println("Message ID: "+messageID.get(i)+"<br>");
			out.println("Sender: "+sentBy.get(i)+"<br>");
			out.println("Message text: "+messageText.get(i)+"<br>");
			if (isResolved.get(i) == true) {
				out.println("Resolved: True <br>");
			} else {
				out.println("Resolved: False <br>");
			}
			out.println("<br>");
			oneMessage=true;
		}
	}
	if (oneMessage==false) {
		out.println("No messages in database matching search parameters. <br>");
		out.println("<br>");
	}
	%>
<a href="messageBrowser.jsp">Back</a>
</body>
</html>
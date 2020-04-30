<!DOCTYPE html>
<html>
<head>
<title>Login Form</title>
</head>
<body>
	<%@ page import="java.sql.*"%>
	<%
	String login = request.getParameter("bt1");
	String createAcct = request.getParameter("bt2");
	
    String userid = request.getParameter("username");   
    String pwd = request.getParameter("password");
    

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
    Statement st = con.createStatement();
    ResultSet rs;
    
    if (login != null) { //Login into existing 
    	rs = st.executeQuery("SELECT * FROM BaseUser WHERE username='" + userid + "' and userPassword='" + pwd + "'");
    	if (rs.next()) { //If information is correct
        	session.setAttribute("BaseUser", userid); // the username will be stored in the session
        	out.println("welcome " + userid);
        	out.println("<a href='logout.jsp'>Log out</a>");
        	response.sendRedirect("landing.jsp");
    	} else { //If information is incorrect
        	out.println("Invalid username or password <a href='index.jsp'>try again</a>");
    	}
    } else if (createAcct != null) { //Make new Account
    	rs = st.executeQuery("SELECT * FROM BaseUser WHERE username='" + userid + "'");
    	if (!(rs.next())) { //If account does not exist
        	//INSERT
        	// System.out.println("INSERT");
    		//Make an insert statement for the Sells table:
    		String insert = "INSERT INTO BaseUser(firstName, lastName, email, userPassword, username)" 
    			+ "VALUES (?, ?, ?, ?, ?)";
    		//Create a Prepared SQL statement allowing you to introduce the parameters of the query
    		PreparedStatement ps = con.prepareStatement(insert);

    		//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
    		ps.setString(1, null);
    		ps.setString(2, null);
    		ps.setString(3, null);
    		ps.setString(4, pwd);
    		ps.setString(5, userid);
    		//Run the query against the DB
    		ps.executeUpdate();

    		String insertCust = "INSERT INTO Customer(zip, city, state, phoneNumber, address, username)" +
					"VALUES (?, ?, ?, ?, ?, ?)";
    		ps = con.prepareStatement(insertCust);
    		ps.setString(1, null);
    		ps.setString(2, null);
    		ps.setString(3, null);
    		ps.setString(4, null);
    		ps.setString(5, null);
    		ps.setString(6, userid);
    		ps.executeUpdate();
    		con.close();
    		
    		out.println("Insert Succeeded! To confirm <a href='index.jsp'>Login Again</a>");
    	} else {
        	out.println("Account already exists <a href='index.jsp'>try again</a>");
    	}
    } else{
    	System.out.println("Neat");
    }
%>
</body>
</html>
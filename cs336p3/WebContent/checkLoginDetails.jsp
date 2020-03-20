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
	
/*  	System.out.println(login);
	System.out.println(createAcct);  */
	
    String userid = request.getParameter("username");   
    String pwd = request.getParameter("password");
    
/*     System.out.println(userid);
	System.out.println(pwd); */
    
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
        	response.sendRedirect("success.jsp");
    	} else { //If information is incorrect
        	out.println("Invalid username or password <a href='index.jsp'>try again</a>");
    	}
    } else if (createAcct != null) { //Make new Account
    	rs = st.executeQuery("SELECT * FROM BaseUser WHERE username='" + userid + "'");
    	if (!(rs.next())) { //If account does not exist
        	//INSERT
        	System.out.println("INSERT");
    	} else {
        	out.println("Account already exists <a href='index.jsp'>try again</a>");
    	}
    } else{
    	System.out.println("Neat");
    }
%>
</body>
</html>
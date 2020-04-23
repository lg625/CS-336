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
    
    out.println(session.getAttribute("BaseUser"));
    
    
%>

<form class="ui large form" action="checkLoginDetails.jsp" method="POST">
		      <div class="ui stacked segment">
		        <div class="field">
		          <div class="ui left icon input">
		            <i class="user icon"></i>
		            <input type="text" name="username" placeholder="Username">
		          </div>
		        </div>
		        <div class="field">
		          <div class="ui left icon input">
		            <i class="lock icon"></i>
		            <input type="password" name="password" placeholder="Password">
		          </div>
		        </div>
		       <input type="submit" value="Login" name="bt1"/>
		       <input type="submit" value="Create account" name="bt2"/>
		      </div>
		      </form>

</body>
</html>
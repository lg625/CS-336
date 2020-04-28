<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Create New Account | Sign-In</title>
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />
	</head>
	<body>
		<div class="ui middle aligned center aligned grid">
		  <div class="column">
		    <h2 class="ui teal image header">
		      <div class="content">
		        Log-in to your account
		      </div>
		    </h2>
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
		  </div>
		</div>
	</body>
</html>
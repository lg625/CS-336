<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<%@ page import="java.sql.*"%>

<% 
	//Button tokens 
	String add = request.getParameter("empResAdd");
	String edit = request.getParameter("empResEdit");
	String delete = request.getParameter("empResDel");

	//SQL Fields 
	// get strings for table
	
	//Button logic 
    if (add != null) {
    	out.print("add");
    	//SQL INSERT
    } else if (edit != null){
    	out.print("edit");
    	//SQL UPDATE
    } else if (delete != null){
    	out.print("delete");
    	//SQL REMOVE
    }
	
%>
</body>
</html>
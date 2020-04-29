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
	//get strings from form
	String emp_res_id = request.getParameter("emp_res_id");
	String emp_customerName = request.getParameter("emp_customerName");
	String emp_dep_id = request.getParameter("emp_dep_id");
	String emp_date = request.getParameter("emp_date");
	String emp_train_id = request.getParameter("emp_train_id");
	String emp_ticket_price = request.getParameter("emp_ticket_price");
	String emp_total = request.getParameter("emp_total");

	//Check if duple
	String select = "SELECT "
	
	PreparedStatement ps = con.prepareStatement(select);
	
	boolean check;
	
	
	
	//Button logic 
    if (add != null) {
    	//out.print("add");
    	
    	if (check == true){
    		
    	}
    	
    	
    	//SQL INSERT
    	String insert = "INSERT INTO bars(name)"
			+ "VALUES (?)";
		
    	PreparedStatement ps0 = con.prepareStatement(insert);
    	//check fail provide reason
    	
    } else if (edit != null){
    	//out.print("edit");
    	//TRUE 
    	
    	//SQL UPDATE
    	String update = "";
	
    	// fail provide reason
    } else if (delete != null){
    	//out.print("delete");
    	//TRUE
    	
    	//SQL REMOVE
    	String delete = "";
    	// fail provide reason
    }
	
%>
</body>
</html>
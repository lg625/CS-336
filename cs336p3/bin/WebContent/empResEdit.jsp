<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>empResEdit</title>
</head>
<body>

<p><a href="empRedirect.jsp">Back</a></p>

<!-- Form -->
<table>
	<tr>
		<td> Add/Edit/Delete a Reservation: 
			
				<form method="post" action="checkResEdit.jsp">
				<table>
				
				<tr>    
				<td>Reservation ID</td><td><input type="text" name="emp_res_id"></td>
				</tr>
				
				<tr>
				<td>Customer Name</td><td><input type="text" name="emp_customerName"></td>
				</tr>
				
				<tr>
				<td>Departure ID</td><td><input type="text" name="emp_dep_id"></td>
				</tr>
				
				<tr>
				<td>Date</td><td><input type="text" name="emp_date"></td>
				</tr>
				
				<tr>
				<td>Train ID</td><td><input type="text" name="emp_train_id"></td>
				</tr>
				
				<tr>
				<td>Ticket Price</td><td><input type="text" name="emp_ticket_price"></td>
				</tr>
				
				<tr>
				<td>Total Cost</td><td><input type="text" name="emp_total"></td>
				</tr>
				
				</table>
				<input type="submit" value="add" name="empResAdd">
				<input type="submit" value="edit" name="empResEdit">
				<input type="submit" value="delete" name="empResDel">
				</form>

		</td>
	</tr>
</table>

<!-- Existing Reservation Table -->
<%
		List<String> list0 = new ArrayList<String>();

		try {	//Get the database connection
/* 			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); */	
			
 			//Create a connection string
			String url = "jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject";
			
/* 		
			//Load JDBC driver
			Class.forName("com.mysql.jdbc.Driver"); */
			
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	        } 
	        catch (ClassNotFoundException e) {
	            System.out.println("MySQL JDBC Driver not found!");
	            return;
	        }
			
			//Connect to DB
			Connection con = DriverManager.getConnection(url, "admin", "s1gnINadmin");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//SQL String
			String str = "SELECT * FROM trainProject.Reservation;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);

			//Make an HTML table to show the results in:
			out.print("<table> Existing Reservations");

			//make a row
			out.print("<tr>");
			
			//make a column
			out.print("<td>");
			//print out column header
			out.print("Ticket Price");
			out.print("</td>");
			
			out.print("<td>");
			out.print("&#160;&#160;&#160;&#160;");
			out.print("</td>");
			
			//make a column
			out.print("<td>");
			out.print("Total");
			out.print("</td>");
			
			out.print("<td>");
			out.print("&#160;&#160;&#160;&#160;");
			out.print("</td>");
			
			//make a column
			out.print("<td>");
			out.print("res date");
			out.print("</td>");
			
			out.print("<td>");
			out.print("&#160;&#160;&#160;&#160;");
			out.print("</td>");
			
			//make a column
			out.print("<td>");
			out.print("res ID");
			out.print("</td>");
			
			out.print("<td>");
			out.print("&#160;&#160;&#160;&#160;");
			out.print("</td>");
			
			//make a column
			out.print("<td>");
			out.print("Customer");
			out.print("</td>");
			
			out.print("<td>");
			out.print("&#160;&#160;&#160;&#160;");
			out.print("</td>");
			
			//make a column
			out.print("<td>");
			out.print("Departure ID");
			out.print("</td>");
			
			out.print("<td>");
			out.print("&#160;&#160;&#160;&#160;");
			out.print("</td>");
			
			//col
			out.print("<td>");
			out.print("Train ID");
			out.print("</td>");
			
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				
				//make a row
				out.print("<tr>");
				
				//make a column
				out.print("<td>");
				//print out column header
				out.print(result.getString("Ticket_Price"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("&#160;&#160;&#160;&#160;");
				out.print("</td>");
				
				//make a column
				out.print("<td>");
				out.print(result.getString("total"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("&#160;&#160;&#160;&#160;");
				out.print("</td>");
				
				//make a column
				out.print("<td>");
				out.print(result.getString("res_date"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("&#160;&#160;&#160;&#160;");
				out.print("</td>");
				
				//make a column
				out.print("<td>");
				out.print(result.getString("res_id"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("&#160;&#160;&#160;&#160;");
				out.print("</td>");
				
				//make a column
				out.print("<td>");
				out.print(result.getString("Purchase_id"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("&#160;&#160;&#160;&#160;");
				out.print("</td>");
				
				//make a column
				out.print("<td>");
				out.print(result.getString("departure_id"));
				out.print("</td>");
				
				out.print("<td>");
				out.print("&#160;&#160;&#160;&#160;");
				out.print("</td>");
				
				//col
				out.print("<td>");
				out.print(result.getString("train_id"));
				out.print("</td>");
				
				out.print("</tr>");
			}
			out.print("</table>");

			//close the connection.
			con.close();

		} catch (Exception e) {
		}
%>

<p>
</p>

<!-- Customer Table -->
<%
		List<String> list1 = new ArrayList<String>();

		try {	//Get the database connection
/* 			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); */	
			
 			//Create a connection string
			String url = "jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject";
			
/* 		
			//Load JDBC driver
			Class.forName("com.mysql.jdbc.Driver"); */
			
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	        } 
	        catch (ClassNotFoundException e) {
	            System.out.println("MySQL JDBC Driver not found!");
	            return;
	        }
			
			//Connect to DB
			Connection con = DriverManager.getConnection(url, "admin", "s1gnINadmin");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//SQL String
			String str = "SELECT username FROM trainProject.Customer;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);

			//Make an HTML table to show the results in:
			out.print("<table>Customer Names");

			//make a row
			out.print("<tr>");
			
			//make a column
			out.print("<td>");
			//print out column header
			out.print("</td>");
			
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				
				//make a row
				out.print("<tr>");
				
				//make a column
				out.print("<td>");
				//print out column header
				out.print(result.getString("username"));
				out.print("</td>");
				out.print("</tr>");
			}
			out.print("</table>");

			//close the connection.
			con.close();

		} catch (Exception e) {
		}
%>

<p>
</p>

<!-- Train ID Table -->
<%
		List<String> list2 = new ArrayList<String>();

		try {	//Get the database connection
/* 			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); */	
			
 			//Create a connection string
			String url = "jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject";
			
/* 		
			//Load JDBC driver
			Class.forName("com.mysql.jdbc.Driver"); */
			
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	        } 
	        catch (ClassNotFoundException e) {
	            System.out.println("MySQL JDBC Driver not found!");
	            return;
	        }
			
			//Connect to DB
			Connection con = DriverManager.getConnection(url, "admin", "s1gnINadmin");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//SQL String
			String str = "SELECT train_id FROM trainProject.Train;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);

			//Make an HTML table to show the results in:
			out.print("<table>Train IDs");

			//make a row
			out.print("<tr>");
			
			//make a column
			out.print("<td>");
			//print out column header
			out.print("</td>");
			
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				
				//make a row
				out.print("<tr>");
				
				//make a column
				out.print("<td>");
				//print out column header
				out.print(result.getString("train_id"));
				out.print("</td>");
				out.print("</tr>");
			}
			out.print("</table>");

			//close the connection.
			con.close();

		} catch (Exception e) {
		}
%>

<p>
</p>

<!-- Train ID Table -->
<%
		List<String> list3 = new ArrayList<String>();

		try {	//Get the database connection
/* 			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); */	
			
 			//Create a connection string
			String url = "jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject";
			
/* 		
			//Load JDBC driver
			Class.forName("com.mysql.jdbc.Driver"); */
			
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	        } 
	        catch (ClassNotFoundException e) {
	            System.out.println("MySQL JDBC Driver not found!");
	            return;
	        }
			
			//Connect to DB
			Connection con = DriverManager.getConnection(url, "admin", "s1gnINadmin");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//SQL String
			String str = "SELECT dep_id FROM trainProject.Departures;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);

			//Make an HTML table to show the results in:
			out.print("<table>Departure IDs");

			//make a row
			out.print("<tr>");
			 
			//make a column
			out.print("<td>");
			//print out column header
			out.print("</td>");
			
			out.print("</tr>");

			//parse out the results
			while (result.next()) {
				
				//make a row
				out.print("<tr>");
				
				//make a column
				out.print("<td>");
				//print out column header
				out.print(result.getString("dep_id"));
				out.print("</td>");
				out.print("</tr>");
			}
			out.print("</table>");

			//close the connection.
			con.close();

		} catch (Exception e) {
		}
%>

</body>
</html>
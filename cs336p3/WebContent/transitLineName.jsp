<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.util.*"%>
<%
String tranLineID=request.getParameter("tranLine");
session.putValue("tranLine",tranLineID);
Class.forName("com.mysql.jdbc.Driver");
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
Statement st= con.createStatement();
ResultSet rs=st.executeQuery("SELECT SUM(r.total) FROM full_reservations r WHERE r.line_name = '"+tranLineID+"'");

ResultSetMetaData rsmd = rs.getMetaData();

try{
	out.println("<TABLE BORDER=1>");
int columnsNumber = rsmd.getColumnCount();
out.println("<TR>");
	out.println("<TH>Total Revenue for Transit Line "+tranLineID+"</TH>");
out.println("</TR>");
   while (rs.next()) {
	   out.println("<TR>");
       for (int i = 1; i <= columnsNumber; i++) {
           out.println("<TD>" + rs.getString(i) + "</TD>");
       }
       out.println("</TR>");
       
   }
   out.println("</TABLE>");
   char quote = '"';
   out.println("<a href=" + quote + "landing.jsp"+quote+">Go back to admin Page</a>");
}
catch (Exception e) {
e.printStackTrace();
out.println("");
response.sendRedirect("listOfRevenue.jsp");
}
%>

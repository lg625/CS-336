<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.util.*"%>
<%
String trainLine=request.getParameter("TrainLine");
session.putValue("TrainLine",trainLine);
Class.forName("com.mysql.jdbc.Driver");
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
Statement st= con.createStatement();
ResultSet rs=st.executeQuery("SELECT * FROM full_reservations WHERE full_reservations.line_name =  '" + trainLine +"'");

ResultSetMetaData rsmd = rs.getMetaData();

try{
	out.println("<TABLE BORDER=1>");
int columnsNumber = rsmd.getColumnCount();
out.println("<TR>");
	out.println("<TH>Reservation(s) by Train Line: "+ trainLine +"</TH>");
out.println("</TR>");
out.println("<TR>");
	out.println("<TH>Username</TH>");
	out.println("<TH>Reservation Date</TH>");
	out.println("<TH>Total Price</TH>");
	out.println("<TH>ReservationID</TH>");
	out.println("<TH>Origin</TH>");
	out.println("<TH>Destination</TH>");
	out.println("<TH>Date of Trip</TH>");
	out.println("<TH>Departs At</TH>");
	out.println("<TH>Arrives At</TH>");
	out.println("<TH>Transit Line</TH>");
	out.println("<TH>Train Number</TH>");
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
   out.println("<a href=" + quote + "admin.jsp"+quote+">Go back to admin Page</a>");
}
catch (Exception e) {
e.printStackTrace();
out.println("");
response.sendRedirect("listOfReservation.jsp");
}
%>
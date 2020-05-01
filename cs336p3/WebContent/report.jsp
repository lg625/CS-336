<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.util.*"%>
<%
String month=request.getParameter("Month");
session.putValue("Month",month);
String year=request.getParameter("Year");
session.putValue("Year",year);
if(month.isEmpty() || year.isEmpty()){
	out.println("Please Enter Values for month and year.");
	char quote2 = '"';
	   out.println("<a href=" + quote2 + "salesReport.jsp"+quote2+">Go Back</a>");
			return;
}
if(month.length() != 2){
	out.println("Please Enter Month in the form of 2 digits.");
	char quote2 = '"';
	   out.println("<a href=" + quote2 + "salesReport.jsp"+quote2+">Go Back</a>");
			return;
}
if(year.length() != 4){
	out.println("Please Enter Year in the form of 4 digits.");
	char quote2 = '"';
	   out.println("<a href=" + quote2 + "salesReport.jsp"+quote2+">Go Back</a>");
			return;
}

if(Integer.parseInt(month) < 01 || Integer.parseInt(month) > 12 ){
	out.println("Please Enter a valid month.");
	char quote3 = '"';
	   out.println("<a href=" + quote3 + "salesReport.jsp"+quote3+">Go Back</a>");
			return;
}
Class.forName("com.mysql.jdbc.Driver");
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
Statement st= con.createStatement();
ResultSet rs=st.executeQuery("SELECT SUM(total) As TotalRevenueForTheMonth FROM OpenReservation WHERE MONTH(res_date) = '"+month+"'" +" AND YEAR(res_date)= '"+year+"'");

ResultSetMetaData rsmd = rs.getMetaData();

try{
	out.println("<TABLE BORDER=1>");
int columnsNumber = rsmd.getColumnCount();
out.println("<TR>");
	out.println("<TH>Total Revenue For the Month of "+ month+ "</TH>");
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
response.sendRedirect("salesReport.jsp");
}
%>
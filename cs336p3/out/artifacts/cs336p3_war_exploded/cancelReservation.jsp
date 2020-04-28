<%--
  Created by IntelliJ IDEA.
  User: cwalsh
  Date: 4/28/20
  Time: 10:54 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reservation Cancelled</title>
</head>
<body>
<%@ page import="java.sql.*"%>
<%
    String id=(String)request.getParameter("id");
    out.println(id);

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con =
                DriverManager.getConnection(
                        "jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject",
                        "admin",
                        "s1gnINadmin");
        Statement st = con.createStatement();

        st.executeUpdate("DELETE FROM Reservation WHERE res_id=" + id);
        out.println("Reservation successfully canceled <a href='landing.jsp'>Return to home screen </a>");
    } catch (Exception e) {
        out.println(e);
    }
%>

</body>
</html>

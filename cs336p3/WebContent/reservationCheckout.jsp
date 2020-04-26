<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Checkout</title>
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%
    String test = request.getParameter("departures");
    out.println(session.getAttribute("BaseUser"));
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
    Statement st = con.createStatement();
    ResultSet rs;

    rs = st.executeQuery("SELECT * FROM full_departures d WHERE d.dep_id = " + test);

    if (rs.next()) {
        out.println("All good!");
    } else {
        out.println("Statement not good");
    }
    if (test != null) {%>
<div><%out.println(test);%></div>
<%}%>
<div>
    <div>
        <form>
            <input type="radio" id="senior" name="discount" value="senior">
            <label for="senior">Senior</label><br>
            <input type="radio" id="child" name="discount" value="child">
            <label for="child">Child</label><br>
            <input type="radio" id="none" name="discount" value="none">
            <label for="none">None</label>
        </form>
    </div>
</div>
</body>
</html>

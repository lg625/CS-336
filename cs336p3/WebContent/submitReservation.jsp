<%--
  Created by IntelliJ IDEA.
  User: cwalsh
  Date: 4/27/20
  Time: 11:16 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reservation confirmed</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Date" %>
<%
    String user = (String) session.getAttribute("BaseUser");
    Integer depId = Integer.parseInt((String) session.getAttribute("DepId"));
    Integer trainId = (Integer) session.getAttribute("Train");
    Double tixPrice = (Double) session.getAttribute("TixPrice");
    String discount = (String) request.getParameter("discount");



    Connection con =
            DriverManager.getConnection(
                    "jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject",
                    "admin",
                    "s1gnINadmin");



    if (discount.equals("senior"))
    {
        tixPrice = tixPrice * 0.65;
    } else if (discount.equals("child") || discount.equals("disabled")) {
        tixPrice = tixPrice * 0.5;
    }

    Date current = new Date(System.currentTimeMillis());
    Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("America/New_York"));
    cal.setTime(current);
    int month = cal.get(Calendar.MONTH);
    int day = cal.get(Calendar.DAY_OF_MONTH);

    String insert = "INSERT INTO Reservation(ticket_price, total, res_date, purchase_id, departure_id, train_id, discount)"
            + "VALUES (?, ?, ?, ?, ?, ?, ?)";
    //Create a Prepared SQL statement allowing you to introduce the parameters of the query
    PreparedStatement ps = con.prepareStatement(insert);

    //Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
    ps.setDouble(1, tixPrice);
    ps.setDouble(2, (tixPrice + 2.00));
    try {
        ps.setDate(3, new java.sql.Date(current.getYear(), month, day));
    } catch (Exception e) {
        out.println(e);
    }
    ps.setString(4, user);
    ps.setInt(5, depId);
    ps.setInt(6, trainId);
    ps.setString(7, discount);
    //Run the query against the DB
    ps.executeUpdate();
    con.close();
    out.println("Reservation confirmed! <a href='landing.jsp'> Return to home screen </a>");
%>

</body>
</html>

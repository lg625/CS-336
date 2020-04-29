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
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Date" %>
<%

    String user = (String) session.getAttribute("BaseUser");
    String line = (String) session.getAttribute("OpenLine");
    Double tixPrice = (Double) session.getAttribute("OpenTixPrice");
    String discount = (String) request.getParameter("discount");
    String type = (String) session.getAttribute("TicketType");

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

    String insert = "INSERT INTO OpenReservation(ticket_price, total, res_date, purchase_id, type, line, discount)"
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
    ps.setString(5, type);
    ps.setString(6, line);
    ps.setString(7, discount);
    ps.executeUpdate();
    con.close();
    out.println("Reservation confirmed! <a href='landing.jsp'> Return to home screen </a>");
%>

</body>
</html>

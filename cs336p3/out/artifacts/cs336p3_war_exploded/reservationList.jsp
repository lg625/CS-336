<%--
  Created by IntelliJ IDEA.
  User: cwalsh
  Date: 4/28/20
  Time: 9:50 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Your reservations</title>
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.LocalDate" %>
<%
    class ReservationItem {
        private String userId;
        private java.sql.Date purchaseDate;
        private int totalPrice;
        private int resId;
        private String originName;
        private String arrivalName;
        private java.sql.Date dep_date;
        private java.sql.Time departs;
        private java.sql.Time arrives;
        private String line;
        private int trainId;

        ReservationItem(
                String userId,
                java.sql.Date purchaseDate,
                int totalPrice,
                int resId,
                String originName,
                String arrivalName,
                java.sql.Date dep_date,
                java.sql.Time departs,
                java.sql.Time arrives,
                String line,
                int trainId
        ) {
            super();
            this.userId = userId;
            this.purchaseDate = purchaseDate;
            this.totalPrice = totalPrice;
            this.resId = resId;
            this.originName = originName;
            this.arrivalName = arrivalName;
            this.dep_date = dep_date;
            this.departs = departs;
            this.arrives = arrives;
            this.line = line;
            this.trainId = trainId;
        }

        String getUserId() {
            return this.userId;
        }

        String getOriginName() {
            return this.originName;
        }

        String getArrivalName() {
            return this.arrivalName;
        }

        String getPurchaseDate() {
            return this.purchaseDate.toString();
        }

        java.sql.Date getDepDate() {
            return this.dep_date;
        }

        String getArrives() {
            return this.arrives.toString();
        }

        String getDeparts() {
            return this.departs.toString();
        }

        int getTrainId() {
            return this.trainId;
        }

        int getTotalPrice() {
            return this.totalPrice;
        }

        String getLine() {
            return this.line;
        }

        int getResId() {
            return this.resId;
        }
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
    Statement st = con.createStatement();
    ResultSet rs;

    String user = (String)session.getAttribute("BaseUser");

    rs = st.executeQuery("SELECT * FROM full_reservations WHERE full_reservations.purchase_id ='" + user + "'");

    List<ReservationItem> res = new ArrayList<ReservationItem>();

    while (rs.next()) {
        String userId = rs.getString("purchase_id");
        java.sql.Date res_date = rs.getDate("res_date");
        int total = rs.getInt("total");
        int resId = rs.getInt("res_id");
        String originName = rs.getString("origin_name");
        String arrivalName = rs.getString("arrival_name");
        java.sql.Date dep_date = rs.getDate("date_dep");
        java.sql.Time arrives  = rs.getTime("arrives");
        java.sql.Time departs = rs.getTime("departs");
        String line = rs.getString("line_name");
        int trainId = rs.getInt("train_id");
        ReservationItem temp = new ReservationItem(userId, res_date, total, resId, originName, arrivalName, dep_date, arrives, departs, line, trainId);
        res.add(temp);
    }

    List<ReservationItem> pastReservations = new ArrayList<ReservationItem>();
    List<ReservationItem> currentReservations = new ArrayList<ReservationItem>();
    LocalDate current = LocalDate.now();
    for (ReservationItem r : res) {
        LocalDate depDateLocal = r.getDepDate().toLocalDate();
        if (depDateLocal.compareTo(current) < 0) {
            pastReservations.add(r);
        } else {
            currentReservations.add(r);
        }
    }
%>
<h3>Current Reservations</h3>
<table border = 1>
    <tr>
    <td>Origin</td>
    <td>Arrival</td>
    <td>Departure Date</td>
    <td>Total Price</td>
    </tr>
<%for (ReservationItem r : currentReservations) {%>
<tr>
    <td><%=r.getOriginName() %></td>
    <td><%=r.getArrivalName() %></td>
    <td><%=r.getDepDate().toString() %></td>
    <td><%=r.getTotalPrice() %></td>
    <td><a href="cancelReservation.jsp?id=<%=r.getResId() %>"><button type="button" class="delete">Cancel Reservation</button></a></td>
</tr>
<%}%>
</table>
<h3>Past Reservations</h3>
<table border = 1>
    <tr>
    <td>Origin</td>
    <td>Arrival</td>
    <td>Departure Date</td>
    <td>Total Price</td>
    </tr>
    <%for (ReservationItem r : pastReservations) {%>
<tr>
    <td><%=r.getOriginName() %></td>
    <td><%=r.getArrivalName() %></td>
    <td><%=r.getDepDate().toString() %></td>
    <td><%=r.getTotalPrice() %></td>
</tr>
<%}%>
</table>
<%
try {
    con.close();
} catch (Exception e) {
        out.println(e);
}
%>
</body>
</html>

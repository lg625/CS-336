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
        private LocalDate purchaseDate;
        private double totalPrice;
        private int resId;
        private String originName;
        private String arrivalName;
        private LocalDate dep_date;
        private String departs;
        private String arrives;
        private String line;
        private int trainId;

        ReservationItem(
                String userId,
                LocalDate purchaseDate,
                double totalPrice,
                int resId,
                String originName,
                String arrivalName,
                LocalDate dep_date,
                String departs,
                String arrives,
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

        LocalDate getDepDate() {
            return this.dep_date;
        }

        String getArrives() {
            return this.arrives;
        }

        String getDeparts() {
            return this.departs;
        }

        int getTrainId() {
            return this.trainId;
        }

        double getTotalPrice() {
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
        LocalDate res_date = LocalDate.parse(rs.getString("res_date"));
        double total = rs.getDouble("total");
        int resId = rs.getInt("res_id");
        String originName = rs.getString("origin_name");
        String arrivalName = rs.getString("arrival_name");
        LocalDate dep_date = LocalDate.parse(rs.getString("date_dep"));
        String arrives  = rs.getString("arrives");
        String departs = rs.getString("departs");
        String line = rs.getString("line_name");
        int trainId = rs.getInt("train_id");
        ReservationItem temp = new ReservationItem(userId, res_date, total, resId, originName, arrivalName, dep_date, arrives, departs, line, trainId);
        res.add(temp);
    }

    List<ReservationItem> pastReservations = new ArrayList<ReservationItem>();
    List<ReservationItem> currentReservations = new ArrayList<ReservationItem>();
    LocalDate current = LocalDate.now();
    for (ReservationItem r : res) {
        LocalDate depDateLocal = r.getDepDate();
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
        <td>Reservation Made</td>
        <td>Origin</td>
        <td>Arrival</td>
        <td>Departure Date</td>
        <td>Departs At</td>
        <td>Arrives At</td>
        <td>Total Price</td>
    </tr>
    <%for (ReservationItem r : currentReservations) {%>
    <tr>
        <td><%=r.getPurchaseDate() %></td>
        <td><%=r.getOriginName() %></td>
        <td><%=r.getArrivalName() %></td>
        <td><%=r.getDepDate().toString() %></td>
        <td><%=r.getArrives() %></td>
        <td><%=r.getDeparts() %></td>
        <td><%=r.getTotalPrice() %></td>
        <td><a href="cancelReservation.jsp?id=<%=r.getResId() %>"><button type="button" class="delete">Cancel Reservation</button></a></td>
    </tr>
    <%}%>
</table>
<h3>Past Reservations</h3>
<table border = 1>
    <tr>
        <td>Reservation Made</td>
        <td>Origin</td>
        <td>Arrival</td>
        <td>Departure Date</td>
        <td>Departs At:</td>
        <td>Arrives At:</td>
        <td>Total Price</td>
    </tr>
    <%for (ReservationItem r : pastReservations) {%>
    <tr>
        <td><%=r.getPurchaseDate() %></td>
        <td><%=r.getOriginName() %></td>
        <td><%=r.getArrivalName() %></td>
        <td><%=r.getDepDate().toString() %></td>
        <td><%=r.getArrives() %></td>
        <td><%=r.getDeparts() %></td>
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

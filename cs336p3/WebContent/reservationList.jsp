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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Duration" %>
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
        private String discount;

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
                int trainId,
                String discount
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
            this.discount = discount;
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

        String getDiscount() {
            if (this.discount.equals("senior")) {
                return "Senior";
            } else if (this.discount.equals("child")) {
                return "Child";
            } else if (this.discount.equals("disabled")) {
                return "Disabled";
            } else {
                return "None";
            }
        }
    }

    class OpenReservationItem {
        private int reservationId;
        private double ticketPrice;
        private double totalPrice;
        private LocalDate purchaseDate;
        private String openType;
        private String line;
        private String discount;

        OpenReservationItem(int reservationId, double ticketPrice, double totalPrice, LocalDate purchaseDate,
                            String openType, String line, String discount) {
            this.reservationId = reservationId;
            this.ticketPrice = ticketPrice;
            this.totalPrice = totalPrice;
            this.purchaseDate = purchaseDate;
            this.openType = openType;
            this.line = line;
            this.discount = discount;
        }

        int getReservationId() {
            return this.reservationId;
        }

        double getTicketPrice() {
            return this.ticketPrice;
        }

        double getTotalPrice() {
            return this.totalPrice;
        }

        LocalDate getPurchaseDate() {
            return this.purchaseDate;
        }

        String getOpenType() {
            return this.openType;
        }

        String correctedOpenType() {
            if (this.openType.equals("round-trip")) {
                return "Round Trip";
            } else if (this.openType.equals("weekly")) {
                return "Weekly";
            } else {
                return "Monthly";
            }
        }

        String getLine() {
            return this.line;
        }

        String getDiscount() {
            if (this.discount.equals("senior")) {
                return "Senior";
            } else if (this.discount.equals("child")) {
                return "Child";
            } else if (this.discount.equals("disabled")) {
                return "Disabled";
            } else {
                return "None";
            }
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
        String discount = rs.getString("discount");
        ReservationItem temp = new ReservationItem(userId, res_date, total, resId, originName, arrivalName, dep_date, arrives, departs, line, trainId, discount);
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

    rs = st.executeQuery("SELECT * FROM OpenReservation WHERE purchase_id = '" + user + "'");

    List<OpenReservationItem> openRes = new ArrayList<OpenReservationItem>();
    while(rs.next()) {
        int resId = rs.getInt("res_id");
        double tixPrice = rs.getDouble("ticket_price");
        double total = rs.getDouble("total");
        LocalDate purchaseDate = LocalDate.parse(rs.getString("res_date"));
        String type = rs.getString("type");
        String line = rs.getString("line");
        String discount = rs.getString("discount");
        OpenReservationItem temp = new OpenReservationItem(resId, tixPrice, total, purchaseDate, type, line, discount);
        openRes.add(temp);
    }

    List<OpenReservationItem> pastOpenRes = new ArrayList<OpenReservationItem>();
    List<OpenReservationItem> currOpenRes = new ArrayList<OpenReservationItem>();

    for (OpenReservationItem o : openRes) {

        long days = Duration.between(o.getPurchaseDate().atStartOfDay(), current.atStartOfDay()).toDays();

        if (o.getOpenType().equals("weekly")) {
            if (days >= 7) {
                pastOpenRes.add(o);
            } else {
                currOpenRes.add(o);
            }
        } else if (o.getOpenType().equals("monthly")) {
            if (days >= 30) {
                pastOpenRes.add(o);
            } else {
                currOpenRes.add(o);
            }
        } else {
            currOpenRes.add(o);
        }
    }
%>
<h3>Current Reservations</h3>
<table class="mt-4 table table-hover table-striped table-bordered">
    <tr>
        <td>Reservation Made</td>
        <td>Origin</td>
        <td>Arrival</td>
        <td>Departure Date</td>
        <td>Departs At</td>
        <td>Arrives At</td>
        <td>Train Number</td>
        <td>Ticket Discount</td>
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
        <td><%=r.getTrainId() %></td>
        <td><%=r.getDiscount() %></td>
        <td><%="$" + String.format("%.2f", r.getTotalPrice()) %></td>
        <td><a href="cancelReservation.jsp?id=<%=r.getResId() %>"><button type="button" class="delete">Cancel Reservation</button></a></td>
    </tr>
    <%}%>
</table >
<h3>Open Passes</h3>
<table class="mt-4 table table-hover table-striped table-bordered">
    <tr>
        <td>Pass Type</td>
        <td>Line</td>
        <td>Purchased On</td>
        <td>Ticket Discount</td>
        <td>Total Price</td>
    </tr>
    <%for (OpenReservationItem o : currOpenRes) {%>
    <tr>
        <td><%=o.correctedOpenType() %></td>
        <td><%=o.getLine() %></td>
        <td><%=o.getPurchaseDate().toString() %></td>
        <td><%=o.getDiscount() %></td>
        <td><%="$" + String.format("%.2f", o.getTotalPrice()) %></td>
        <td><a href="cancelOpenReservation.jsp?id=<%=o.getReservationId()%>"><button type="button" class="delete">Cancel Pass</button></a></td>
    </tr>
    <%}%>
</table>
<h3>Expired Passes</h3>
<table class="mt-4 table table-hover table-striped table-bordered">
    <tr>
        <td>Pass Type</td>
        <td>Line</td>
        <td>Purchased On</td>
        <td>Ticket Discount</td>
        <td>Total Price</td>
    </tr>
    <%for (OpenReservationItem o : pastOpenRes) {%>
    <tr>
        <td><%=o.correctedOpenType() %></td>
        <td><%=o.getLine() %></td>
        <td><%=o.getPurchaseDate().toString() %></td>
        <td><%=o.getDiscount() %></td>
        <td><%="$" + String.format("%.2f", o.getTotalPrice()) %></td>
    </tr>
    <%}%>
</table>
    <h3>Past Reservations</h3>

    <table class="mt-4 table table-hover table-striped table-bordered">

        <tr>
            <td>Reservation Made</td>
            <td>Origin</td>
            <td>Arrival</td>
            <td>Departure Date</td>
            <td>Departs At:</td>
            <td>Arrives At:</td>
            <td>Train Number</td>
            <td>Ticket Discount</td>
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
            <td><%=r.getTrainId() %></td>
            <td><%=r.getDiscount() %></td>
            <td><%="$" + String.format("%.2f", r.getTotalPrice()) %></td>
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

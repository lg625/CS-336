<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Checkout</title>
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%

    class Departure {
        private int depId;
        private int originId;
        private int arrivalId;
        private String originName;
        private String arrivalName;
        private java.sql.Date dep_date;
        private java.sql.Time arrives;
        private java.sql.Time departs;
        private int trainId;
        private String line;
        private double totalCost;
        private int scheduleId;

        Departure(int depId,
                  int originId,
                  int arrivalId,
                  String originName,
                  String arrivalName,
                  java.sql.Date dep_date,
                  java.sql.Time arrives,
                  java.sql.Time departs,
                  int trainId,
                  String line,
                  double totalCost,
                  int scheduleId) {
            super();
            this.depId = depId;
            this.originId = originId;
            this.arrivalId = arrivalId;
            this.originName = originName;
            this.arrivalName = arrivalName;
            this.dep_date = dep_date;
            this.arrives = arrives;
            this.departs = departs;
            this.trainId = trainId;
            this.line = line;
            this.totalCost = totalCost;
            this.scheduleId = scheduleId;
        }

        String getOriginName() {
            return this.originName;
        }

        String getArrivalName() {
            return this.arrivalName;
        }

        String getLine() {
            return this.line;
        }

        int getScheduleId() {
            return this.scheduleId;
        }
    }

    String departure_id = request.getParameter("departures");
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con =
            DriverManager.getConnection(
                    "jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject",
                    "admin",
                    "s1gnINadmin");

    Statement st = con.createStatement();
    ResultSet rs;

    rs = st.executeQuery("SELECT * FROM full_departures d WHERE d.dep_id = " + departure_id);

    Departure depart;
    if (rs.next()) {
        session.setAttribute("DepId", departure_id);
        int depId = rs.getInt("dep_id");
        String originName = rs.getString("origin_name");
        String arrivalName = rs.getString("arrival_name");
        int originId = rs.getInt("origin_id");
        int arrivalId = rs.getInt("arrival_id");
        int trainId = rs.getInt("train_id");
        String line = rs.getString("line_name");
        java.sql.Date dep_date = rs.getDate("date_dep");
        java.sql.Time arrives  = rs.getTime("arrives");
        java.sql.Time departs = rs.getTime("departs");
        double total = rs.getDouble("total_fare");
        int schedule_id = rs.getInt("schedule_id");
        session.setAttribute("Train", trainId);
        depart = new Departure(depId, originId, arrivalId, originName, arrivalName,
                dep_date, arrives, departs, trainId, line, total, schedule_id);



        rs = st.executeQuery("SELECT * FROM stop_groups s where s.schedule_id = " + depart.getScheduleId());


        Set<String> stops = new LinkedHashSet<String>();

        Set<String> origins = new HashSet<String>();
        Set<String> arrivals = new HashSet<String>();

        while (rs.next()) {
            String origin = rs.getString("origin_name");
            String arrival = rs.getString("arrival_name");

            origins.add(origin);
            arrivals.add(arrival);
        }

        for (String s : origins) {
            stops.add(s);
        }

        for (String s : arrivals) {
            stops.add(s);
        }

        int stopCount = stops.size()-1;
        double adjustedPrice = depart.totalCost / stopCount;

        int count = 0;
        boolean isStart = false;
        for (String s : stops) {
            if (isStart) {
                count += 1;
            }

            if (depart.getOriginName().equals(s)) {
                isStart = true;
            }

            if (depart.getArrivalName().equals(s)) {
                break;
            }
        }

        adjustedPrice = adjustedPrice * count;
        out.println("You selected: </br>");

        double actualTotal = adjustedPrice + 2.00;
        session.setAttribute("TixPrice", adjustedPrice);
%>
<div>
    <div id="line"><%out.print("<b>Line:</b> " + depart.getLine());%></div>
    <div id="origin"><%out.print("<b>Origin:</b> " + depart.getOriginName());%></div>
    <div id="arrival"><%out.print("<b>Arrival:</b> " + depart.getArrivalName());%></div>
    <div id="ticket-price"><%out.print("<b>Ticket Price:</b> " + String.format("%.2f",adjustedPrice));%></div>
    <div id="fee-total"><%out.print("<b>Total:</b> " + "$" + String.format("%.2f",adjustedPrice)
                                    + " + $2.00" + " = " + "$" + String.format("%.2f", actualTotal));%></div>
</div>


<script>
    window.radioSwitcher = function(radio) {
        if (radio.id === "senior") {
            console.log("senior");
        } else if (radio.id === "child") {
            console.log("child");
        } else if (radio.id === "disabled") {
            console.log("disabled");
        } else {
            console.log("none");
        }
    }

    window.generateActual = function(price) {
        return "Total: ".bold() + "$" + parseFloat(price.toFixed(2)) + " + "
               + "$2.00" + " = " + "$" + parseFloat((price + 2).toFixed(2));
    }

    window.onload = function () {

        var radioElements = document.querySelectorAll("input[type=radio]");
        var tixPrice = <% out.print(adjustedPrice); %>;
        var seniorPrice = tixPrice * 0.65;
        var childPrice = tixPrice * 0.50;
        var ticketLabel = document.getElementById("ticket-price");
        var actualLabel = document.getElementById("fee-total");

        for (var i = 0; i < radioElements.length; i++) {
            radioElements[i].addEventListener("change", function (evt) {
                if (this.id === "senior") {
                    ticketLabel.innerHTML = "Adjusted Ticket Price: ".bold() + parseFloat(seniorPrice.toFixed(2));
                    actualLabel.innerHTML = window.generateActual(seniorPrice);
                    actualLabel.value = seniorPrice + 2;
                } else if (this.id === "child" || this.id === "disabled") {
                    ticketLabel.innerHTML = "Adjusted Ticket Price: ".bold() + parseFloat(childPrice.toFixed(2));
                    actualLabel.innerHTML = window.generateActual(childPrice);
                    actualLabel.value = childPrice + 2;
                } else {
                    ticketLabel.innerHTML = "Ticket Price: ".bold() + parseFloat(tixPrice.toFixed(2));
                    actualLabel.innerHTML = window.generateActual(tixPrice);
                    actualLabel.value = tixPrice + 2;
                }
            })
        }

    }
</script>

<div>
    <div>
        <form action="submitReservation.jsp" method="POST">
            <input type="radio" id="senior" name="discount" value="senior">
            <label for="senior">Senior</label><br>
            <input type="radio" id="child" name="discount" value="child">
            <label for="child">Child</label><br>
            <input type="radio" id="disabled" name="discount" value="disabled">
            <label for="disabled">Disabled</label><br>
            <input type="radio" id="none" name="discount" value="none">
            <label for="none">None</label>
            </br>
            <input id="make_reservation" type="submit" value="Make Reservation" name="make_reservation"/>
        </form>
    </div>
</div>
<%
    } else {
        out.println("Oops, something went wrong!");
    }
%>
</body>
</html>

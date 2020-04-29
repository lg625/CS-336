<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Checkout</title>
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.LocalDate" %>
<%

    class Departure {
        private int depId;
        private int originId;
        private int arrivalId;
        private String originName;
        private String arrivalName;
        private LocalDate dep_date;
        private String arrives;
        private String departs;
        private int trainId;
        private String line;
        private double totalCost;
        private int scheduleId;

        Departure(int depId,
                  int originId,
                  int arrivalId,
                  String originName,
                  String arrivalName,
                  LocalDate dep_date,
                  String arrives,
                  String departs,
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

        String getArrives() {
            return this.arrives;
        }

        String getDeparts() {
            return this.departs;
        }

        LocalDate getDepDate() {
            return this.dep_date;
        }

        int getTrainId() {
            return this.trainId;
        }
    }

    String ticketType = request.getParameter("ticket-type");
    String openLine = request.getParameter("line-open");



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
        LocalDate dep_date = LocalDate.parse(rs.getString("date_dep"));
        String arrives  = rs.getString("arrives");
        String departs = rs.getString("departs");
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

        double actualTotal = adjustedPrice + 2.00;
        session.setAttribute("TixPrice", adjustedPrice);

        rs = st.executeQuery("SELECT * FROM train_count_by_departure tcount WHERE tcount.dep_id = " + departure_id);

        int totalCapacity = 0;
        int resCount = 0;
        if (rs.next()) {
            totalCapacity = rs.getInt("seats");
            resCount = rs.getInt("res_count");
        }
        totalCapacity = totalCapacity - resCount;
%>
<div>

    <div id="res-count"><%=totalCapacity > 0 ? "There are " + totalCapacity + " seats left on this train" :
            "No seats available please select another line <a href='reservation.jsp'> Go Back to Reservations </a>"%>
    </div>
    </br>
    <div id="one-way">
        You selected:
        <div>
            <div id="line"><%out.print("<b>Line:</b> " + depart.getLine());%></div>
            <div id="train"><%out.print("<b>Train:</b> " + depart.getTrainId());%></div>
            <div id="origin"><%out.print("<b>Origin:</b> " + depart.getOriginName());%></div>
            <div id="arrival"><%out.print("<b>Arrival:</b> " + depart.getArrivalName());%></div>
            <div id="arrives"><%out.print("<b>Departs:</b> " + depart.getDeparts());%></div>
            <div id="departs"><%out.print("<b>Arrives:</b> " + depart.getArrives());%></div>
            <div id="depart-date"><%out.print("<b>Date of Departure:</b> " + depart.getDepDate().toString());%></div>
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

                var resCount = document.getElementById("res-count");


                var radioElements = document.querySelectorAll("input[type=radio]");
                var tixPrice = <% out.print(adjustedPrice); %>;
                var seniorPrice = tixPrice * 0.65;
                var childPrice = tixPrice * 0.50;
                var ticketLabel = document.getElementById("ticket-price");
                var actualLabel = document.getElementById("fee-total");

                if (resCount.innerHTML === "No seats available please select another line <a href='reservation.jsp'> Go Back to Reservations </a>") {
                    var oneWay = document.getElementById("one-way");
                    oneWay.style.display = "none";
                }

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
                    <input type="radio" id="none" name="discount" value="none" checked>
                    <label for="none">None</label>
                    </br>
                    <input id="make_reservation" type="submit" value="Make Reservation" name="make_reservation"/>
                </form>
            </div>
        </div>
    </div>
    <%
    } else if (openLine != null){
        rs = st.executeQuery("SELECT * FROM schedule_flat WHERE name = '" + openLine + "'");

        double ticketPrice = 0;
        if (rs.next()) {
            ticketPrice = rs.getDouble("total_fare");
            ticketPrice = (ticketPrice * 2);

            if (ticketType.equals("round-trip")) {
                out.println("Round Trip Tickets are double the max fare (with a 10% discount) </br>" +
                        "since they allow you to ride any train as long as there is space.</br></br>");
                ticketPrice = ticketPrice + (ticketPrice*0.10);
            } else if (ticketType.equals("weekly")) {
                out.println("Weekly Tickets are double the max fare per day for 7 days (with a 10% discount) </br>" +
                        "since they allow you to ride any train as long as there is space.</br></br>");
                ticketPrice = (ticketPrice * 7);
                ticketPrice = ticketPrice + (ticketPrice*0.10);
            } else {
                out.println("Monthly Tickets are double the max fare per day for 30 days (with a 10% discount) </br>" +
                        "since they allow you to ride any train as long as there is space.</br></br>");
                ticketPrice = (ticketPrice * 30);
                ticketPrice = ticketPrice + (ticketPrice*0.10);
            }

            out.println("<b>Your selected line is: </b>" + openLine);
            session.setAttribute("OpenTixPrice", ticketPrice);
            session.setAttribute("OpenLine", openLine);
            session.setAttribute("TicketType", ticketType);
        }

    %>
    <div id="open">
        <div id="open-ticket-price"><%out.print("<b>Ticket Price:</b> " + String.format("%.2f",ticketPrice));%></div>
        <div id="open-fee-total"><%out.print("<b>Total:</b> " + "$" + String.format("%.2f",ticketPrice)
                    + " + $2.00" + " = " + "$" + String.format("%.2f", (ticketPrice + 2.00)));%></div>
        <script>

            window.generateActual = function(price) {
                return "Total: ".bold() + "$" + parseFloat(price.toFixed(2)) + " + "
                    + "$2.00" + " = " + "$" + parseFloat((price + 2).toFixed(2));
            }

            window.onload = function () {

                var radioElements = document.querySelectorAll("input[type=radio]");
                var tixPrice = <%=ticketPrice%>;
                var seniorPrice = tixPrice * 0.65;
                var childPrice = tixPrice * 0.50;
                var ticketLabel = document.getElementById("open-ticket-price");
                var actualLabel = document.getElementById("open-fee-total");

                for (var i = 0; i < radioElements.length; i++) {
                    radioElements[i].addEventListener("change", function () {
                        if (this.id === "open-senior") {
                            ticketLabel.innerHTML = "Adjusted Ticket Price: ".bold() + parseFloat(seniorPrice.toFixed(2));
                            actualLabel.innerHTML = window.generateActual(seniorPrice);
                            actualLabel.value = seniorPrice + 2;
                        } else if (this.id === "open-child" || this.id === "open-disabled") {
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
            <form action="submitOpenReservation.jsp" method="POST">
                <input type="radio" id="open-senior" name="discount" value="senior">
                <label for="senior">Senior</label><br>
                <input type="radio" id="open-child" name="discount" value="child">
                <label for="child">Child</label><br>
                <input type="radio" id="open-disabled" name="discount" value="disabled">
                <label for="disabled">Disabled</label><br>
                <input type="radio" id="open-none" name="discount" value="none" checked>
                <label for="none">None</label>
                </br>
                <input id="open_make_reservation" type="submit" value="Make Reservation" name="open_make_reservation"/>
            </form>
        </div>
    </div>
    <%} else {
        out.println("Oops, something went wrong!");
    }
    try {
        con.close();
    } catch (Exception e){
        out.println("Could not close connection");
        out.println(e);
    }%>
</div>

</body>
</html>

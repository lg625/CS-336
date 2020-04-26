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

        int getId() {
            return this.depId;
        }

        int getOriginId() {
            return this.originId;
        }

        int getArrivalId() {
            return this.arrivalId;
        }

        String getOriginName() {
            return this.originName;
        }

        String getArrivalName() {
            return this.arrivalName;
        }

        String getDate() {
            return this.dep_date.toString();
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

        String getLine() {
            return this.line;
        }

        double getTotalCost() {
            return this.totalCost;
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
        int depId = rs.getInt("dep_id");
        String originName = rs.getString("origin_name");
        String arrivalName = rs.getString("arrival_name");
        int originId = rs.getInt("origin_id");
        int arrivalId = rs.getInt("arrival_id");
        String line = rs.getString("line_name");
        int trainId = rs.getInt("train_id");
        java.sql.Date dep_date = rs.getDate("date_dep");
        java.sql.Time arrives  = rs.getTime("arrives");
        java.sql.Time departs = rs.getTime("departs");
        double total = rs.getDouble("total_fare");
        int schedule_id = rs.getInt("schedule_id");
        depart = new Departure(depId, originId, arrivalId, originName, arrivalName,
                               dep_date, arrives, departs, trainId, line, total, schedule_id);

        out.println("You selected: </br>" +
                    "<b>Line:</b> " + depart.getLine() +
                    "</br><b>Origin:</b> " + depart.getOriginName() +
                    "</br><b>Arrival:</b> " + depart.getArrivalName() +
                    "</br><b>Total:</b> " + depart.getTotalCost());

        rs = st.executeQuery("SELECT * FROM stop_groups s where s.schedule_id = " + depart.getScheduleId());


        Set<String> origins = new HashSet<String>();
        Set<String> arrivals = new HashSet<String>();

        while (rs.next()) {
            String origin = rs.getString("origin_name");
            String arrival = rs.getString("arrival_name");

            origins.add(origin);
            arrivals.add(arrival);
        }

        int stopCount = origins.size();
        double adjustedPrice = depart.totalCost / stopCount;

        for (String s : origins) {
            
            out.println(s);
        }

        for (String s : arrivals) {
            out.println(s);
        }

    } else {
        out.println("Oops, something went wrong!");
    }
%>
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

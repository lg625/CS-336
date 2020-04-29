<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Make a Reservation</title>
    <style>
        #departures option {
            font-family: Consolas, monospace;
        }
    </style>
</head>
<body>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    class Departure {
        private int depId;
        private int originId;
        private int arrivalId;
        private String originName;
        private String arrivalName;
        private java.sql.Date dep_date;
        private String arrives;
        private String departs;
        private int trainId;
        private String line;

        Departure(int depId,
                  int originId,
                  int arrivalId,
                  String originName,
                  String arrivalName,
                  java.sql.Date dep_date,
                  String arrives,
                  String departs,
                  int trainId,
                  String line) {
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
            return this.arrives;
        }

        String getDeparts() {
            return this.departs;
        }

        int getTrainId() {
            return this.trainId;
        }

        String getLine() {
            return this.line;
        }
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
    Statement st = con.createStatement();
    ResultSet rs;



    rs = st.executeQuery("SELECT * FROM full_departures");

    List<Departure> dep = new ArrayList<Departure>();

    LocalDate current = LocalDate.now();
    while (rs.next()) {
        int depId = rs.getInt("dep_id");
        String originName = rs.getString("origin_name");
        String arrivalName = rs.getString("arrival_name");
        int originId = rs.getInt("origin_id");
        int arrivalId = rs.getInt("arrival_id");
        String line = rs.getString("line_name");
        int trainId = rs.getInt("train_id");
        java.sql.Date dep_date = rs.getDate("date_dep");
        String arrives = rs.getString("arrives");
        String departs = rs.getString("departs");
        LocalDate depDateLocal = dep_date.toLocalDate();
        if (depDateLocal.compareTo(current) > 0) {
            Departure temp = new Departure(depId, originId, arrivalId, originName, arrivalName, dep_date, arrives, departs, trainId, line);
            dep.add(temp);
        }
    }

    Set<String> uniqueLines = new HashSet<String>();
    Set<String> uniqueOrigins = new HashSet<String>();
    Set<String> uniqueArrivals = new HashSet<String>();
    Set<String> uniqueDates = new HashSet<String>();
    Set<String> uniqueDepTime = new HashSet<String>();
    Set<String> uniqueArrTime = new HashSet<String>();


    for (Departure d : dep) {
        uniqueLines.add(d.getLine());
        uniqueOrigins.add(d.getOriginName());
        uniqueArrivals.add(d.getArrivalName());
        uniqueDates.add(d.getDate());
        uniqueDepTime.add(d.getDeparts());
        uniqueArrTime.add(d.getArrives());

    }

%>
<script>
    //Global
    var departureArr = [];
    <% for (Departure d : dep) { %>
    var newObj = {id: "<% out.print(d.getId()); %>",
        line: "<% out.print(d.getLine()); %>",
        originId: "<% out.print(d.getOriginId()); %>",
        arrivalId: "<% out.print(d.getArrivalId()); %>",
        originName: "<% out.print(d.getOriginName()); %>",
        arrivalName: "<% out.print(d.getArrivalName()); %>",
        trainId: "<% out.print(d.getTrainId()); %>",
        date: "<% out.print(d.getDate()); %>",
        departTime: "<% out.print(d.getDeparts()); %>",
        arrivalTime: "<% out.print(d.getArrives()); %>"

    };
    departureArr.push(newObj);
    <% } %>

</script>

<form class="ui large form" action="reservationCheckout.jsp" method="POST">
    <div>
        Select Ticket Type:</br>
        <select id="ticket-type" name="ticket-type">
                <option value="one-way" selected>One-Way</option>
                <option value="round-trip">Round Trip</option>
                <option value="weekly">Weekly</option>
                <option value="monthly">Monthly</option>
        </select>
    </div>
    </br>
    <div class="ui stacked segment">
        <div id="open-ticket">
            <div>
                Select train line:</br>
                <select id="line-open" name="line-open">
                    <option value="line-no-val" selected>--</option>
                    <% for (String s : uniqueLines) { %>
                    <option value="<% out.print(s); %>"><% out.println(s); %></option>
                    <% } %>
                </select>
            </div>
            </br>
        </div>
        <div id="one-way">
            <div>
                Select train line:</br>
                <select id="line">
                    <option value="line-no-val">--</option>
                    <% for (String s : uniqueLines) { %>
                    <option value="<% out.print(s); %>"><% out.println(s); %></option>
                    <% } %>
                </select>
            </div>
            </br>
            <div>
                <!-- Adjust origin depending on line? -->
                Select station of departure:</br>
                <select id="origin">
                    <option value="origin-no-val">--</option>
                    <% for (String s : uniqueOrigins) { %>
                    <option value="<% out.print(s); %>"><% out.println(s); %></option>
                    <% } %>
                </select>
            </div>
            </br>
            <div>
                Select station of arrival:</br>
                <select id="arrivals">
                    <option value="arrival-no-val">--</option>
                    <% for (String s : uniqueArrivals) { %>
                    <option value="<% out.print(s); %>"><% out.println(s); %></option>
                    <% } %>
                </select>
            </div>
            </br>
            <div>
                Select date:</br>
                <select id="date">
                    <option value="date-no-val">--</option>
                    <% for (String s : uniqueDates) { %>
                    <option value="<% out.print(s); %>"><% out.println(s); %></option>
                    <% } %>
                </select>
            </div>
            </br>
            <div>
                Select time:</br>
                Leaving:
                <select id="depart-time">
                    <option value="dep-time-no-val">--</option>
                    <% for (String s : uniqueDepTime) { %>
                    <option value="<% out.print(s); %>"><% out.println(s); %></option>
                    <% } %>
                </select>
                Arrives:
                <select id="arrival-time">
                    <option value="arr-time-no-val">--</option>
                    <% for (String s : uniqueArrTime) { %>
                    <option value="<% out.print(s); %>"><% out.println(s); %></option>
                    <% } %>
                </select>
            </div>
            </br>
            <div>
                Departures:</br>
                <script type="application/javascript">

                    window.emptyList = function(list) {
                        length = list.length;
                        for (var i = length-1; i >= 0; i--) {
                            list[i] = null;
                        }
                    }

                    window.generateOptions = function(arr, selectList) {
                        for (var i = 0; i < arr.length; i++) {
                            var item = arr[i];
                            var option = document.createElement("option");
                            option.value = item.id;
                            option.text = "Origin/Arrival: " + item.originName + " to " + item.arrivalName +
                                " -- Line: " + item.line + " -- Train#: " + item.trainId +
                                " -- Date: " + item.date + " -- Departs: " + item.departTime +
                                " -- Arrives: " + item.arrivalTime;
                            selectList.options.add(option);
                        }
                    }

                    window.checkNull = function(selectList, selectedLine, originSelected, arrivalSelected,
                                                dateSelected, depTimeSelected, arrTimeSelected) {

                        var allNull = selectedLine === '--' && originSelected === '--' && arrivalSelected === '--' &&
                            dateSelected === '--' && depTimeSelected === '--' && arrTimeSelected === '--';

                        if (selectList.options.length === 0 || allNull) {
                            length = selectList.options.length;
                            for (var i = length-1; i >= 0; i--) {
                                selectList.options[i] = null;
                            }
                            var option = document.createElement("option");
                            option.value = "no-val";
                            option.text = "No departures that match that criteria, try adjusting your parameters";
                            selectList.options.add(option);
                        }
                    }

                    window.filterOptions = function(departureArr, selectedLine, originSelected, arrivalSelected,
                                                    dateSelected, depTimeSelected, arrTimeSelected) {

                        var tempArr = departureArr.slice(0);

                        tempArr = selectedLine !== '--' ? tempArr.filter(
                            function (value) { return selectedLine === value.line}) : tempArr;

                        tempArr = originSelected !== '--' ? tempArr.filter(
                            function (value) { return originSelected === value.originName }) : tempArr;

                        tempArr = arrivalSelected !== '--' ? tempArr.filter(
                            function (value) { return arrivalSelected === value.arrivalName }) : tempArr;

                        tempArr = dateSelected !== '--' ? tempArr.filter(
                            function (value) { return dateSelected === value.date }) : tempArr;

                        tempArr = depTimeSelected !== '--' ? tempArr.filter(
                            function (value) { return depTimeSelected === value.departTime }) : tempArr;

                        tempArr = arrTimeSelected !== '--' ? tempArr.filter(
                            function (value) { return arrTimeSelected === value.arrivalTime }) : tempArr;

                        return tempArr;
                    }

                    window.valueChange = function(lineVals, originVals, arrivalVals, selectList, dateList, depTimeList, arrTimeList) {
                        var selectedLine = lineVals.options[lineVals.selectedIndex].text;
                        var originSelected = originVals.options[originVals.selectedIndex].text;
                        var arrivalSelected = arrivalVals.options[arrivalVals.selectedIndex].text;
                        var dateSelected = dateList.options[dateList.selectedIndex].text;
                        var depTimeSelected = depTimeList.options[depTimeList.selectedIndex].text;
                        var arrTimeSelected = arrTimeList.options[arrTimeList.selectedIndex].text;

                        window.emptyList(selectList.options);

                        var tempArr = window.filterOptions(departureArr, selectedLine, originSelected, arrivalSelected,
                            dateSelected, depTimeSelected, arrTimeSelected);

                        window.generateOptions(tempArr, selectList);

                        window.checkNull(selectList, selectedLine, originSelected, arrivalSelected, dateSelected, depTimeSelected, arrTimeSelected);

                    }

                    window.shouldHideSubmit = function(submit, bool) {
                        submit.disabled = bool;
                    }

                    window.onload = function () {

                        var submit = document.getElementById("checkout");
                        window.shouldHideSubmit(submit, true);

                        var open = document.getElementById("open-ticket");
                        var oneWay = document.getElementById("one-way");
                        open.style.display = "none";

                        var ticketType = document.getElementById("ticket-type");
                        var lineVals = document.getElementById("line");
                        var originVals = document.getElementById("origin");
                        var arrivalVals = document.getElementById("arrivals");
                        var dateList = document.getElementById("date");
                        var depTimeList = document.getElementById("depart-time");
                        var arrTimeList = document.getElementById("arrival-time");

                        var openLine = document.getElementById("line-open");

                        var selectList = document.getElementById("departures");

                        ticketType.onchange = function() {
                            var selectedType = ticketType.options[ticketType.selectedIndex].value;

                            if (selectedType === "one-way") {
                                oneWay.style.display = "block";
                                open.style.display = "none";
                            } else {
                                oneWay.style.display = "none";
                                open.style.display = "block";
                            }
                        }

                        openLine.onchange = function () {
                            var openSel =  openLine.options[openLine.selectedIndex].value;
                            if (openSel !== "line-no-val") {
                                window.shouldHideSubmit(submit, false);
                            }
                        }

                        lineVals.onchange = function () {
                            window.valueChange(lineVals, originVals, arrivalVals, selectList, dateList, depTimeList, arrTimeList);
                        };

                        originVals.onchange = function () {
                            window.valueChange(lineVals, originVals, arrivalVals, selectList, dateList, depTimeList, arrTimeList);
                        };

                        arrivalVals.onchange = function () {
                            window.valueChange(lineVals, originVals, arrivalVals, selectList, dateList, depTimeList, arrTimeList);
                        };

                        dateList.onchange = function () {
                            window.valueChange(lineVals, originVals, arrivalVals, selectList, dateList, depTimeList, arrTimeList);
                        };

                        depTimeList.onchange = function () {
                            window.valueChange(lineVals, originVals, arrivalVals, selectList, dateList, depTimeList, arrTimeList);
                        };

                        arrTimeList.onchange = function () {
                            window.valueChange(lineVals, originVals, arrivalVals, selectList, dateList, depTimeList, arrTimeList);
                        };

                        selectList.onclick = function () {
                            var selectedLine =  selectList.options[selectList.selectedIndex].value;
                            if (selectedLine !== "no-val") {
                                window.shouldHideSubmit(submit, false);
                            }
                        }
                    };

                </script>

                <select name="departures" id="departures" size="5">
                    <option value="no-val">No departures that match that criteria, try adjusting your parameters</option>
                </select>
            </div>
            </br>
        </div>
        <input id="checkout" type="submit" value="Go to Checkout" name="checkout"/>
    </div>
</form>

</body>
</html>
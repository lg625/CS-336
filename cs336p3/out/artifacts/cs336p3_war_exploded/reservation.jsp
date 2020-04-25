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
<%
    class Departure {
        private int depId;
        private int originId;
        private int arrivalId;
        private String originName;
        private String arrivalName;
        private int trainId;
        private String line;

        Departure(int depId, int originId, int arrivalId, String originName, String arrivalName, int trainId, String line) {
            super();
            this.depId = depId;
            this.originId = originId;
            this.arrivalId = arrivalId;
            this.originName = originName;
            this.arrivalName = arrivalName;
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

    out.println(session.getAttribute("BaseUser"));

    rs = st.executeQuery("SELECT * FROM full_departures");

    List<Departure> dep = new ArrayList<Departure>();

    while (rs.next()) {
        int depId = rs.getInt("dep_id");
        String originName = rs.getString("origin_name");
        String arrivalName = rs.getString("arrival_name");
        int originId = rs.getInt("origin_id");
        int arrivalId = rs.getInt("arrival_id");
        String line = rs.getString("line_name");
        int trainId = rs.getInt("train_id");
        out.println(rs.getDate("date_dep"));
        out.println(rs.getTime("arrives"));
        out.println(rs.getTime("departs"));
        Departure temp = new Departure(depId, originId, arrivalId, originName, arrivalName, trainId, line);
        dep.add(temp);
    }

    Set<String> uniqueLines = new HashSet<String>();
    Set<String> uniqueOrigins = new HashSet<String>();
    Set<String> uniqueArrivals = new HashSet<String>();

    for (Departure d : dep) {
        uniqueLines.add(d.getLine());
        uniqueOrigins.add(d.getOriginName());
        uniqueArrivals.add(d.getArrivalName());
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
        trainId: "<% out.print(d.getTrainId()); %>"
    };
    departureArr.push(newObj);
    <% } %>

</script>

<form class="ui large form" action="checkLoginDetails.jsp" method="POST">
    <div class="ui stacked segment">
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
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getArrivalId()); %>"><% out.println(d.getArrivalName()); %></option>
                <% } %>
            </select>
        </div>
        </br>
        <div>
            Select time:</br>
            Leaving:
            <select id="dep-time">
                <option value="dep-time-no-val">--</option>
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getArrivalId()); %>"><% out.println(d.getArrivalName()); %></option>
                <% } %>
            </select>
            Arrives:
            <select id="arrival-time">
                <option value="arr-time-no-val">--</option>
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getArrivalId()); %>"><% out.println(d.getArrivalName()); %></option>
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
                        option.text = "Origin/Arrival: " + item.originName + " to " + item.arrivalName + " -- Line: " + item.line + " -- Train#: " + item.trainId;
                        selectList.options.add(option);
                    }
                }

                window.checkNull = function(selectList, selectedLine, originSelected, arrivalSelected) {

                    var allNull = selectedLine === '--' && originSelected === '--' && arrivalSelected === '--';
                    if (selectList.options.length === 0 || allNull) {
                        length = selectList.options.length;
                        for (var i = length-1; i >= 0; i--) {
                            selectList.options[i] = null;
                        }
                        var option = document.createElement("option");
                        option.text = "No departures that match that criteria, try adjusting your parameters";
                        selectList.options.add(option);
                    }
                }

                window.filterOptions = function(departureArr, selectedLine, originSelected, arrivalSelected) {
                    var tempArr = departureArr.slice(0);

                    tempArr = tempArr !== '--' ? tempArr.filter(function (value) { return selectedLine === value.line}) : tempArr;
                    tempArr = originSelected !== '--' ? tempArr.filter(function (value) { return originSelected === value.originName }) : tempArr;
                    tempArr = arrivalSelected !== '--' ? tempArr.filter(function (value) { return arrivalSelected === value.arrivalName }) : tempArr;
                    return tempArr;
                }

                window.valueChange = function(lineVals, originVals, arrivalVals, selectList) {
                    var selectedLine = lineVals.options[lineVals.selectedIndex].text;
                    var originSelected = originVals.options[originVals.selectedIndex].text;
                    var arrivalSelected = arrivalVals.options[arrivalVals.selectedIndex].text;

                    window.emptyList(selectList.options);

                    var tempArr = window.filterOptions(departureArr, selectedLine, originSelected, arrivalSelected);

                    window.generateOptions(tempArr, selectList);

                    window.checkNull(selectList, selectedLine, originSelected, arrivalSelected);
                }

                window.onload = function (ev) {

                    var lineVals = document.getElementById("line");
                    var originVals = document.getElementById("origin");
                    var arrivalVals = document.getElementById("arrivals");
                    var selectList = document.getElementById("departures");

                    lineVals.onchange = function () {
                        window.valueChange(lineVals, originVals, arrivalVals, selectList);
                    };

                    originVals.onchange = function () {
                        window.valueChange(lineVals, originVals, arrivalVals, selectList);
                    };

                    arrivalVals.onchange = function () {
                        window.valueChange(lineVals, originVals, arrivalVals, selectList);
                    };
                };
            </script>
            <select id="departures" size="3">
                <option>No departures that match that criteria, try adjusting your parameters</option>
                <!--
		          	 <% //for (Departure d : dep) { %>
                         <option value=<%// d.getId(); %>><% //out.println(d.getOrigin() + " to " + d.getArrival() + " " + d.getLine()); %></option>
		         	 <% //} %>

		         	 -->
            </select>
        </div>
        <input type="submit" value="Submit" name="bt1"/>
    </div>
</form>

</body>
</html>
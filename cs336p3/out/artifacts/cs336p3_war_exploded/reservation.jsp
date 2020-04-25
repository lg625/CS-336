<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
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
        Departure temp = new Departure(depId, originId, arrivalId, originName, arrivalName, trainId, line);
        dep.add(temp);
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
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getLine()); %>"><% out.println(d.getLine()); %></option>
                <% } %>
            </select>
        </div>
        <div>
            <!-- Adjust origin depending on line? -->
            Select station of departure:</br>
            <select id="origin">
                <option value="origin-no-val">--</option>
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getOriginId()); %>"><% out.println(d.getOriginName()); %></option>
                <% } %>
            </select>
        </div>
        <div>
            Select station of arrival:</br>
            <select id="arrivals">
                <option value="arrival-no-val">--</option>
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getArrivalId()); %>"><% out.println(d.getArrivalName()); %></option>
                <% } %>
            </select>
        </div>
        <div>
            Select date:</br>
            <select id="date">
                <option value="date-no-val">--</option>
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getArrivalId()); %>"><% out.println(d.getArrivalName()); %></option>
                <% } %>
            </select>
        </div>
        <div>
            Select station of arrival:</br>
            <select id="arrivals">
                <option value="arrival-no-val">--</option>
                <% for (Departure d : dep) { %>
                <option value="<% out.print(d.getArrivalId()); %>"><% out.println(d.getArrivalName()); %></option>
                <% } %>
            </select>
        </div>
        <div>
            Departures:</br>
            <script type="application/javascript">

                window.emptyList = function(list) {
                    length = list.length;
                    for (i = length-1; i >= 0; i--) {
                        list[i] = null;
                    }
                }

                window.generateOptions = function(arr, selectList) {
                    for (i = 0; i < arr.length; i++) {
                        item = arr[i];
                        option = document.createElement("option");
                        option.value = item.id;
                        option.text = item.originName + " to " + item.arrivalName + " " + item.line + " Train#: " + item.trainId;
                        selectList.options.add(option);
                    }
                }

                window.checkNull = function(selectList, selectedLine, originSelected, arrivalSelected) {

                    allNull = selectedLine === '--' && originSelected === '--' && arrivalSelected === '--';
                    if (selectList.options.length === 0 || allNull) {
                        length = selectList.options.length;
                        for (i = length-1; i >= 0; i--) {
                            selectList.options[i] = null;
                        }
                        option = document.createElement("option");
                        option.text = "No departures that match that criteria, try adjusting your parameters";
                        selectList.options.add(option);
                    }
                }

                window.filterOptions = function(departureArr, selectedLine, originSelected, arrivalSelected) {
                    tempArr = departureArr.slice(0);

                    tempArr = tempArr !== '--' ? tempArr.filter(function (value) { return selectedLine === value.line}) : tempArr;
                    tempArr = originSelected !== '--' ? tempArr.filter(function (value) { return originSelected === value.originName }) : tempArr;
                    tempArr = arrivalSelected !== '--' ? tempArr.filter(function (value) { return arrivalSelected === value.arrivalName }) : tempArr;
                    return tempArr;
                }

                window.valueChange = function(lineVals, originVals, arrivalVals, selectList) {
                    selectedLine = lineVals.options[lineVals.selectedIndex].text;
                    originSelected = originVals.options[originVals.selectedIndex].text;
                    arrivalSelected = arrivalVals.options[arrivalVals.selectedIndex].text;

                    window.emptyList(selectList.options);

                    tempArr = window.filterOptions(departureArr, selectedLine, originSelected, arrivalSelected);

                    window.generateOptions(tempArr, selectList);

                    window.checkNull(selectList, selectedLine, originSelected, arrivalSelected);
                }

                window.onload = function (ev) {

                    lineVals = document.getElementById("line");
                    originVals = document.getElementById("origin");
                    arrivalVals = document.getElementById("arrivals");
                    selectList = document.getElementById("departures");

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
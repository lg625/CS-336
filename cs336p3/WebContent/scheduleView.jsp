<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Date Time Picker Reference -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/momentjs/2.14.1/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/css/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<!-- Bootstrap Table Sorting Reference -->
<link href="https://unpkg.com/bootstrap-table@1.16.0/dist/bootstrap-table.min.css" rel="stylesheet">
<script src="https://unpkg.com/bootstrap-table@1.16.0/dist/bootstrap-table.min.js"></script>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<meta charset="ISO-8859-1">
<title>Train Schedule View</title>

<script>	
	$(document).ready(function () {
		parseURL();
	});
</script>
</head>

<body>
	<%@ page import="java.sql.*, java.util.ArrayList, java.util.Date, model.TrainSchedule, java.text.SimpleDateFormat"%>
	<%
		Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection(
			"jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject", "admin", "s1gnINadmin");
	Statement st = con.createStatement();
	String sqlStatement = request.getQueryString() == null ? TrainSchedule.createSQLStatement("") : TrainSchedule.createSQLStatement(request.getQueryString());
	ResultSet rs = st.executeQuery(sqlStatement);
	ArrayList<TrainSchedule> schedules = new ArrayList<TrainSchedule>();	// ArrayList used to display objects onto table

	while (rs.next()) {
		String line_name = rs.getString("line_name"), departureTime = rs.getString("departs"), arrivalTime = rs.getString("arrives"), 
				origin_name = rs.getString("origin_name"), arrival_name = rs.getString("arrival_name"), date_dep = rs.getString("date_dep"),
				total_fare = rs.getString("total_fare");
		SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
		Date init = format.parse(arrivalTime), fin = format.parse(departureTime);
		long timeDifference = init.getTime() - fin.getTime();
		String stops = null, travelTime = (timeDifference / (60 * 60 * 1000) % 24) + " hr " + (timeDifference / (60 * 1000) % 60) + " min";
		TrainSchedule m = new TrainSchedule(line_name, stops, origin_name, arrival_name, departureTime, arrivalTime, travelTime, date_dep, total_fare);
		schedules.add(m);
	}
	%>
	
	<div class="container">
		<!-- Back Button -->
		<div class="row mt-3">
			<div class="col-sm">
				<button class="btn btn-secondary" type="button" id="backButton" onclick="backBtnClick()"> Return Home </button>
			</div>
		</div>
		
		<!-- Title Header -->
		<h1 class="mt-4">Train Schedule View</h1>
		
		<!-- Row of Filter Buttons -->
		<div class="row mt-4">
			<!-- Origin Station Filter Button -->
			<div class="col-sm">
				<label class="control-label">Filter Origin Station</label>
				<div class="dropdown">
					<button class="btn btn-secondary dropdown-toggle" type="button" id="origin_nameDropdown" data-toggle="dropdown">
						Origin Station
					</button>
					<ul class="dropdown-menu">
						<li><button class="dropdown-item" type="button"
							onclick="dropdownSelect('origin_name', 'all')"> All Origin Stations</button></li>
						<%
							ArrayList<String> set = new ArrayList<String>();
							for (TrainSchedule t : schedules) {
								if(!set.contains(t.origin_name)) {
									%>
									<li><button class="dropdown-item" type="button" onclick="dropdownSelect('origin_name', '<%=t.origin_name%>')">
											<%=t.origin_name%>
									</button></li>
									<%
									set.add(t.origin_name);
								}
							}
						%>
					</ul>
				</div>
			</div>
			
			<!-- Arrival Station Filter Button -->
			<div class="col-sm">
				<label class="control-label">Filter Arrival Station</label>
				<div class="dropdown">
					<button class="btn btn-secondary dropdown-toggle" type="button" id="arrival_nameDropdown" data-toggle="dropdown">
						Arrival Station
					</button>
					<ul class="dropdown-menu">
						<li><button class="dropdown-item" type="button"
							onclick="dropdownSelect('arrival_name', 'all')"> All Arrival Stations</button></li>
						<%
							set = new ArrayList<String>();
							for (TrainSchedule t : schedules) {
								if(!set.contains(t.arrival_name)) {
									%>
									<li><button class="dropdown-item" type="button" onclick="dropdownSelect('arrival_name', '<%=t.arrival_name%>')">
											<%=t.arrival_name%>
									</button></li>
									<%
									set.add(t.arrival_name);
								}
							}
						%>
					</ul>
				</div>
			</div>
			
			<!-- Travel Date Filter Button -->
			<div class="col-sm">
				<label class="control-label">Filter Travel Date</label>
				<div class="dropdown">
					<button class="btn btn-secondary dropdown-toggle" type="button" id="date_depDropdown" data-toggle="dropdown"> Travel Date </button>
					<ul class="dropdown-menu">
						<li><button class="dropdown-item" type="button"
							onclick="dropdownSelect('date_dep', 'all')"> All Travel Dates</button></li>
						<%
							set = new ArrayList<String>();
							for (TrainSchedule t : schedules) {
								if(!set.contains(t.date_dep)) {
									%>
									<li><button class="dropdown-item" type="button" onclick="dropdownSelect('date_dep', '<%=t.date_dep%>')">
											<%=t.date_dep%>
									</button></li>
									<%
									set.add(t.date_dep);
								}
							}
						%>
					</ul>
				</div>
			</div>
			
			<!-- Reset Filters Button -->
			<div class="col-sm">
				<label class="control-label">Reset Filters</label>
				<div><button class="btn btn-secondary" onclick="buildURL('reset', 'reset')" id="resetBtn">Reset</button></div>
			</div>
		</div>
		
		<!-- Table View -->
		<table class="mt-4 table table-hover table-striped table-bordered" data-toggle="table" data-sort-class="table-active" data-sortable="true" id="scheduleTable">
			<!-- Table Header -->
			<thead>
				<tr>
					<th data-field="numStops" data-sortable="false"># of Stops</th>
					<th data-field="transitLine" data-sortable="false">Transit Line</th>
					<th data-field="startTime" data-sortable="true">Departure Time</th>
					<th data-field="startStation" data-sortable="true">Departure Station</th>
					<th data-field="endTime" data-sortable="true">Arrival Time</th>
					<th data-field="endStation" data-sortable="true">Arrival Station</th>
					<th data-field="travelTime" data-sortable="false">Travel Time</th>
					<th data-field="travelDate" data-sortable="false">Travel Date</th>
					<th data-field="travelFare" data-sortable="true">Travel Fare</th>
				</tr>
			</thead>
			
			<!-- Table Body -->
			<tbody id="table-body">
				<%
					for (int i = 0; i < schedules.size(); i++) {
					TrainSchedule t = schedules.get(i);
				%>
				<tr>
					<th scope="row"><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModalCenter" onclick="setModalText('<%=i%>')">View Stops</button></th>
					<td><%=t.transitLine%></td>
					<td><%=t.deptTime%></td>
					<td><%=t.origin_name%></td>
					<td><%=t.arrivalTime%></td>
					<td><%=t.arrival_name%></td>
					<td><%=t.totalTime%></td>
					<td><%=t.date_dep%></td>
					<td><%=t.total_fare%></td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
		
		<!-- Template Modal -->
		<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
		  <div class="modal-dialog modal-dialog-centered" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLongTitle">Modal title</h5>
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <div class="modal-body">
		        ...
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
		      </div>
		    </div>
		  </div>
		</div>
	</div>

	<script>			
		function setModalText(index) {
			console.log("selected index = " + index);
			var modal = $('#exampleModalCenter');
			modal.find('.modal-title').text("Selected Index = " + index);
			modal.find('.modal-body').text("TODO: Display train stops");		// TODO: Display train stops and times (optional)
		}
		
		// Parses URL and sets up initial UI based on parameters
		function parseURL() {
			var urlParams = new URLSearchParams(location.search);
			
			for(let entry of urlParams.entries()) {
				var filterGroup = entry[0], filterValue = entry[1];
				//console.log("\tparseURL: group = " + filterGroup + ", value = " + filterValue);
				document.getElementById(filterGroup + "Dropdown").innerHTML = filterValue;
				document.getElementById(filterGroup + "Dropdown").classList.remove("btn-secondary");
				document.getElementById(filterGroup + "Dropdown").classList.add("btn-primary");
			}
		}
		
		// Build new URL based on selected filter buttons and reload page
		function buildURL(filterGroup, filterValue) {
			var urlParams = new URLSearchParams(location.search);
			
			if(filterGroup == 'reset'){
				urlParams = "";
			}
			else if(urlParams.has(filterGroup)) {
				// if filterValue = "all", remove filterGroup param
				if(filterValue == "all")
					urlParams.delete(filterGroup);
				else
					urlParams.set(filterGroup, filterValue);
			}
			else {
				if(filterValue != "all")
					urlParams.append(filterGroup, filterValue);
			}
				
			window.location.assign('scheduleView.jsp?'+urlParams);
		}
		
		function dropdownSelect(filterGroup, filterValue) {		
			// Change button text to be selected value and change color
			if(filterValue != 'all') {
				document.getElementById(filterGroup + "Dropdown").innerHTML = filterValue;
				document.getElementById(filterGroup + "Dropdown").classList.remove("btn-secondary");
				document.getElementById(filterGroup + "Dropdown").classList.add("btn-primary");
			}
			
			buildURL(filterGroup, filterValue);
		}
		
		function backBtnClick() {
			window.location.assign("scheduleViewHome.jsp");
		}
	</script>
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Date Time Picker Reference -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/momentjs/2.14.1/moment.min.js"></script>

<!-- Bootstrap Table Sorting Reference -->
<link href="https://unpkg.com/bootstrap-table@1.16.0/dist/bootstrap-table.min.css" rel="stylesheet">
<script src="https://unpkg.com/bootstrap-table@1.16.0/dist/bootstrap-table.min.js"></script>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<meta charset="ISO-8859-1">
<title>Train Schedule View</title>

<script>	
	$(document).ready(function () {
		parseURL();
	});
</script>
</head>

<body>
	<%@ page import="java.sql.*, java.util.ArrayList, java.util.Date, java.text.SimpleDateFormat"%>
	
	<%
	class TrainSchedule {
		public String line_name, numStops, origin_name, arrival_name, arrivalTime, deptTime, totalTime, date_dep, total_fare, schedule_id;
		
		public TrainSchedule(String line_name, String numStops, String originStation, String arrivalStation, String deptTime, String arrivalTime, String totalTime, 
								String date_dep, String total_fare, String schedule_id) {
			this.line_name = line_name;
			this.numStops = numStops;
			this.origin_name = originStation;
			this.arrival_name = arrivalStation;
			this.arrivalTime = arrivalTime;
			this.deptTime = deptTime;
			this.totalTime = totalTime;
			this.date_dep = date_dep;
			this.total_fare = total_fare;
			this.schedule_id = schedule_id;
		}
		
		public TrainSchedule(){
			
		}
		
		// Get urlParameter input and convert to become readable for an SQL query
		String createSQLStatement(String urlParameters) {		
			String output = "SELECT * FROM trainProject.full_departures", filter = "";
			
			// example input: transitLine=NorthEast+Corridor
			if(urlParameters.length() == 0 || urlParameters == null)
				return output;
			else {
				filter = " WHERE ";
				String[] parameters = urlParameters.split("&");
				
				// go through each parameter and append to output string
				for(int i = 0; i < parameters.length; i++) {
					String parameter[] = parameters[i].split("=");
					
					if(parameter[0].contains("index")) {
						if(i == 0)
							filter = "";
						break;
					}
					
					// check if parameter value has any spaces
					if(parameter[1].contains("+") || parameter[1].contains("-")) {
						parameter[1] = parameter[1].replace("+", " ");
						parameter[1] = "'" + parameter[1] + "'";
					}
					
					//System.out.println("parameter: " + parameter[0] + " = " + parameter[1]);
					if(i != 0)
						filter = filter.concat(" AND ");
					
					filter = filter.concat(parameter[0] + " = " + parameter[1]);
				}
			}
			
			return output + filter;
		}
	}
	
		Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection(
			"jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject", "admin", "s1gnINadmin");
	Statement st = con.createStatement();
	TrainSchedule y = new TrainSchedule();
	String sqlStatement = request.getQueryString() == null ? y.createSQLStatement("") : y.createSQLStatement(request.getQueryString());
	ResultSet rs = st.executeQuery(sqlStatement);
	ArrayList<TrainSchedule> schedules = new ArrayList<TrainSchedule>();	// ArrayList used to display objects onto table
	ArrayList<TrainSchedule> trainStops = new ArrayList<TrainSchedule>();	// Arraylist used to display stops for train schedule
	TrainSchedule selectedSchedule = null;
	String trainStopsText = null;

	while (rs.next()) {
		String line_name = rs.getString("line_name"), departureTime = rs.getString("departs"), arrivalTime = rs.getString("arrives"), 
				origin_name = rs.getString("origin_name"), arrival_name = rs.getString("arrival_name"), date_dep = rs.getString("date_dep"),
				total_fare = rs.getString("total_fare"), schedule_id = rs.getString("schedule_id");
		SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
		Date init = format.parse(arrivalTime), fin = format.parse(departureTime);
		long timeDifference = init.getTime() - fin.getTime();
		String stops = null, travelTime = (timeDifference / (60 * 60 * 1000) % 24) + " hr " + (timeDifference / (60 * 1000) % 60) + " min";
		TrainSchedule m = new TrainSchedule(line_name, stops, origin_name, arrival_name, departureTime, arrivalTime, travelTime, date_dep, total_fare, schedule_id);
		schedules.add(m);
	}
	
	// URL Index Parameter exists, filter list of schedules and generate stops
	if(request.getParameter("index") != null){
		selectedSchedule = schedules.get(Integer.parseInt(request.getParameter("index")));
		rs = st.executeQuery("SELECT * FROM full_departures WHERE schedule_id='" + selectedSchedule.schedule_id + "'");
		
		while (rs.next()) {
			String origin_name = rs.getString("origin_name"), arrival_name = rs.getString("arrival_name"), total_fare = rs.getString("total_fare");
			TrainSchedule m = new TrainSchedule(null, null, origin_name, arrival_name, null, null, null, null, total_fare, null);
			trainStops.add(m);
		}
		
		// Find index of train stop
		int trainStopOrder = 0;
		for(TrainSchedule t : trainStops) {
			if(selectedSchedule.arrival_name.equals(t.arrival_name) && selectedSchedule.origin_name.equals(t.origin_name)){
				break;
			}
			trainStopOrder++;
		}
		
		// Remove every stop before selected stop
		while(trainStopOrder >= 0) {
			trainStops.remove(trainStopOrder);
			trainStopOrder--;
		}
		
		// Create new string containing stops
		trainStopsText = "";
		for(TrainSchedule t: trainStops) {
			if(trainStopsText.contains(t.origin_name) == false) {
				trainStopsText += t.origin_name;
				if(trainStops.indexOf(t) < trainStops.size()-1)
					trainStopsText += " -> ";
			}
		}
	}
	%>
	
	<div class="container-fluid px-5">
		<!-- Back Button -->
		<div class="row mt-4">
			<div class="col-sm">
				<button class="btn btn-outline-secondary" type="button" id="backButton" onclick="backBtnClick()"> Return Home </button>
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
									<li><button class="dropdown-item" type="button"
										onclick="dropdownSelect('date_dep', '<%=t.date_dep%>')">
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
					<th data-field="travelDate" data-sortable="false">Travel Date</th>
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
					<td><%=t.line_name + " (" + t.schedule_id + ")"%></td>
					<td><%=t.deptTime%></td>
					<td><%=t.origin_name%></td>
					<td><%=t.arrivalTime%></td>
					<td><%=t.arrival_name%></td>
					<td><%=t.date_dep%></td>
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
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="closeModal()">
		          <span aria-hidden="true">&times;</span>
		        </button>
		      </div>
		      <div class="modal-body">
		        ...
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="closeModal()">Close</button>
		      </div>
		    </div>
		  </div>
		</div>
	</div>

	<script>			
		function setModalText(index) {
			var urlParams = new URLSearchParams(location.search);
			
			if(urlParams.has("index") == false || (urlParams.has("index") && urlParams.get("index") != index)) {
				urlParams.set("index", index);
				document.location = ("scheduleView.jsp?" + urlParams);
			}

			var modal = $('#exampleModalCenter').modal();
			modal.find('.modal-title').text("" + '<%=(selectedSchedule == null ? "Generating Stops" : selectedSchedule.origin_name + " -> " + selectedSchedule.arrival_name)%>');
			modal.find('.modal-body').text("" + '<%=trainStopsText%>');		
		}
		
		// Function called when close button clicked
		function closeModal() {
			var urlParams = new URLSearchParams(location.search);
			urlParams.delete("index");
			document.location = ("scheduleView.jsp?" + urlParams);
		}
		
		// Parses URL and sets up initial UI based on parameters
		function parseURL() {
			var urlParams = new URLSearchParams(location.search);
			
			for(let entry of urlParams.entries()) {
				var filterGroup = entry[0], filterValue = entry[1];
				
				if(filterGroup == 'index')	{
					setModalText(filterValue);
				}
				else{
					//console.log("\tparseURL: group = " + filterGroup + ", value = " + filterValue);
					document.getElementById(filterGroup + "Dropdown").innerHTML = filterValue;
					document.getElementById(filterGroup + "Dropdown").classList.remove("btn-secondary");
					document.getElementById(filterGroup + "Dropdown").classList.add("btn-primary");
				}
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Bootstrap CSS Reference -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<meta charset="ISO-8859-1">
<title>Train Schedule View</title>

<script>	
	$(document).ready(function () {
		// Filter drop down options based on user input
		$("#originStationFilter").on("keyup", function() {
		    var value = $(this).val().toLowerCase();
		    $(".originStationFilter li").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
		    });
		});
		
		$("#arrivalStationFilter").on("keyup", function() {
		    var value = $(this).val().toLowerCase();
		    $(".arrivalStationFilter li").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
		    });
		});
	});
</script>
</head>

<body>
	<%@ page
		import="java.sql.*, java.util.ArrayList"%>
	<%
		Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection(
			"jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject", "admin", "s1gnINadmin");
	Statement st = con.createStatement();
	String sqlStatement = "SELECT DISTINCT arrival_name, origin_name, date_dep FROM full_departures;";
	ResultSet rs = st.executeQuery(sqlStatement);
	ArrayList<String> stationNames = new ArrayList<String>(), travelDates = new ArrayList<String>(); // ArrayList used to display drop down station list

	while (rs.next()) {
		String arrival_name = rs.getString("arrival_name"), origin_name = rs.getString("origin_name"), date_dep = rs.getString("date_dep");
		if(stationNames.contains(arrival_name) == false)
			stationNames.add(arrival_name); 
		
		if(stationNames.contains(origin_name) == false)
			stationNames.add(origin_name);
		
		if(travelDates.contains(date_dep) == false)
			travelDates.add(date_dep);
	}
	%>

	<div class="container">
		<h1 class="mt-4">Train Schedule View - Home</h1>

		<!-- Row of Filter Buttons -->
		<div class="row mt-4">
			<!-- Origin Station Filter Button -->
			<div class="col">
				<label class="control-label">Origin Station</label>
				<div class="dropdown">
					<button class="btn btn-secondary dropdown-toggle" type="button" id="origin_nameDropdown" data-toggle="dropdown">Origin Station</button>
					<ul class="dropdown-menu originStationFilter">
						<input class="form-control" id="originStationFilter" type="text" placeholder="Search..">
						<%
							for (String stationName : stationNames) {
						%>
						<li><button class="dropdown-item" type="button" onclick="dropdownSelect('origin_name', '<%=stationName%>')">
								<%=stationName%>
							</button></li>
						<%
							}
						%>
					</ul>
				</div>
			</div>
			
			<!-- Arrival Station Filter Button -->
			<div class="col">
				<label class="control-label">Arrival Station</label>
				<div class="dropdown">
					<button class="btn btn-secondary dropdown-toggle" type="button" id="arrival_nameDropdown" data-toggle="dropdown">Arrival Station</button>
					<ul class="dropdown-menu arrivalStationFilter">
						<input class="form-control" id="arrivalStationFilter" type="text" placeholder="Search..">
						<%
							for (String stationName : stationNames) {
						%>
						<li><button class="dropdown-item" type="button" onclick="dropdownSelect('arrival_name', '<%=stationName%>')">
								<%=stationName%>
							</button></li>
						<%
							}
						%>
					</ul>
				</div>
			</div>
		</div>
		
		<div class="row mt-4">
			<!-- Date Filter Button -->
			<div class="col">
				<label class="control-label">Date Select</label>
				<div class="dropdown">
					<button class="btn btn-secondary dropdown-toggle" type="button" id="date_depDropdown" data-toggle="dropdown">Date Filter</button>
					<ul class="dropdown-menu date_depFilter">
						<input class="form-control" id="date_depFilter" type="text" placeholder="Search..">
						<%
							for (String travelDate : travelDates) {
						%>
						<li><button class="dropdown-item" type="button" onclick="dropdownSelect('date_dep', '<%=travelDate%>')">
								<%=travelDate%>
							</button></li>
						<%
							}
						%>
					</ul>
				</div>
			</div>
			
			<!-- Check Schedule Button -->
			<div class="col">
				<div class="mt-4">
					<button class="btn btn-outline-primary" type="button" id="checkScheduleBtn" onclick="checkSchedule()">Check Schedule</button>
				</div>
			</div>
		</div>
		
		<!-- View All Schedules Button -->
		<div class="row mt-4">
			<div class="col"></div>
			<div class="col">
				<button class="btn btn-outline-secondary" type="button" onclick="dropdownSelect('all', 'all')"> View All Schedules </button>
			</div>
		</div>

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
					<div class="modal-body">...</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		function checkSchedule() {
			var originStation = document.getElementById("origin_nameDropdown").innerHTML, 
					arrivalStation = document.getElementById("arrival_nameDropdown").innerHTML,
					dateSelect = document.getElementById("date_depDropdown").innerHTML;
			var isOriginDefault = originStation == "Origin Station" ? true : false, 
					isArrivalDefault = arrivalStation == "Arrival Station" ? true : false,
					isDateDefault = dateSelect == "Date Filter" ? true : false;
			var urlParams = new URLSearchParams(location.search);
			
			// No Origin value selected, display pop up
			if(isOriginDefault) {
				$("#exampleModalCenter").modal("show");
				$('#exampleModalCenter').find('.modal-title').text('Error');
				$('#exampleModalCenter').find('.modal-body').text("Please select an origin station.");
				return;
			}
			
			// Origin selected
			if(!isOriginDefault)
				urlParams.set("origin_name", originStation);
			
			// Arrival selected
			if(!isArrivalDefault)
				urlParams.set("arrival_name", arrivalStation);
			
			// Date Selected
			if(!isDateDefault)
				urlParams.set("date_dep", dateSelect);
			
			window.location.assign("scheduleView.jsp?" + urlParams);
		}
		
		function dropdownSelect(filterGroup, filterValue) {				
			// Change button text to be selected value and change color
			if(filterGroup != 'all' && filterValue != 'all') {
				document.getElementById(filterGroup + "Dropdown").innerHTML = filterValue;
				document.getElementById(filterGroup + "Dropdown").classList.remove("btn-secondary");
				document.getElementById(filterGroup + "Dropdown").classList.add("btn-primary");
			}
			else{
				window.location.assign("scheduleView.jsp");		// redirect to schedule view and display all schedules
			}
			
		}
	</script>
	
	<!-- Bootstrap JS Reference -->
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
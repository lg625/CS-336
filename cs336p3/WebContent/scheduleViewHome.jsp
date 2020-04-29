<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<meta charset="ISO-8859-1">
<title>Train Schedule View</title>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

<script>	
	$(document).ready(function () {
		// Filter drop down options based on user input
		$("#origin_nameFilter").on("keyup", function() {
		    var value = $(this).val().toLowerCase();
		    $(".origin_nameFilter li").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
		    });
		});
		
		$("#arrival_nameFilter").on("keyup", function() {
		    var value = $(this).val().toLowerCase();
		    $(".arrival_nameFilter li").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
		    });
		});
	});
</script>

</head>

<body>
	<!-- 1. Fetch all stations
		2. Display station options on to origin and destination drop down buttons 
		3. On "View Schedules" button click, check if schedule goes from origin to destination
			if valid, redirect to schedule view page (disable station filters)
			else display warning "Stations do not have an intersecting schedule" 
		4. Underneath all elements add "View All Schedules" link
			redirects to default schedule view -->

	<%@ page
		import="java.sql.*, java.util.ArrayList, java.util.Date, model.TrainSchedule, java.text.SimpleDateFormat"%>
	<%
		Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection(
			"jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject", "admin", "s1gnINadmin");
	Statement st = con.createStatement();
	String sqlStatement = "SELECT DISTINCT name FROM Station;";
	ResultSet rs = st.executeQuery(sqlStatement);
	ArrayList<String> stationNames = new ArrayList<String>(); // ArrayList used to display drop down station list

	while (rs.next()) {
		String stationName = rs.getString("name");
		stationNames.add(stationName);

		/*SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
		Date init = format.parse(arrivalTime), fin = format.parse(departureTime);
		long timeDifference = init.getTime() - fin.getTime();
		String travelTime = (timeDifference / (60 * 60 * 1000) % 24) + " hr " + (timeDifference / (60 * 1000) % 60) + " min";
		TrainSchedule m = new TrainSchedule(transitLine, stops, originStation, arrivalStation, departureTime, arrivalTime, travelTime, date_dep);*/
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
					<ul class="dropdown-menu origin_nameFilter">
						<input class="form-control" id="origin_nameFilter" type="text" placeholder="Search..">
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
					<ul class="dropdown-menu arrival_nameFilter">
						<input class="form-control" id="arrival_nameFilter" type="text" placeholder="Search..">
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
					<button class="btn btn-secondary dropdown-toggle" type="button" id="date_depDropdown" data-toggle="dropdown"> Date Filter</button>
					<ul class="dropdown-menu date_depFilter">
						<input class="form-control" id="date_depFilter" type="text" placeholder="Search..">
						<%
							for (String stationName : stationNames) {
						%>
						<li><button class="dropdown-item" type="button" onclick="dropdownSelect('date_dep', '<%=stationName%>')">
								<%=stationName%>
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
					<button class="btn btn-primary" type="button" id="checkScheduleBtn" onclick="checkSchedule()">Check Schedule</button>
				</div>
			</div>
		</div>

		<!-- Template Modal -->
		<div class="modal fade" id="exampleModalCenter" tabindex="-1"
			role="dialog" aria-labelledby="exampleModalCenterTitle"
			aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLongTitle">Modal
							title</h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">...</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>			
		function myFunction(index) {
			console.log("selected index = " + index);
			var modal = $('#exampleModalCenter');
			modal.find('.modal-title').text('Selected Index = ' + index);
			modal.find('.modal-body').text(index);		// TODO: Display train stops and times (optional)
		}
		
		function checkSchedule() {
			var originStation = document.getElementById("origin_nameDropdown").innerHTML, 
					arrivalStation = document.getElementById("arrival_nameDropdown").innerHTML,
					dateSelect = document.getElementById("date_depDropdown").innerHTML;
			var isOriginDefault = originStation == "Origin Station" ? true : false, 
					isArrivalDefault = arrivalStation == "Arrival Station" ? true : false,
					isDateDefault = dateSelect == "Date Filter" ? true : false;
			var urlParams = new URLSearchParams(location.search);

			console.log("isOriginDefault = " + isOriginDefault + ", isArrivalDefault = " + isArrivalDefault + ", isDateDefault = " + isDateDefault);
			
			if(isOriginDefault && isArrivalDefault && isDateDefault) {
				// Please select an input
				console.log("Please select an input");
			}
			
			if(isOriginDefault) {		// Default value
				// Please select an origin station pop up
				console.log("Please select an origin station pop up");
			}
			
			// Origin and Arrival stations selected
			if(!isOriginDefault && !isArrivalDefault) {
				urlParams.set("origin_name", originStation);
				urlParams.set("arrival_name", arrivalStation);
				window.location.assign("scheduleView.jsp?" + urlParams);	// redirect
			}
			
			// Only Origin station selected
			if(!isOriginDefault) {
				urlParams.set("origin_name", originStation);
				window.location.assign("scheduleView.jsp?" + urlParams);
			}
		}
		
		function dropdownSelect(filterGroup, filterValue) {				
			// Change button text to be selected value and change color
			if(filterValue != 'all') {
				document.getElementById(filterGroup + "Dropdown").innerHTML = filterValue;
				document.getElementById(filterGroup + "Dropdown").classList.remove("btn-secondary");
				document.getElementById(filterGroup + "Dropdown").classList.add("btn-primary");
			}
		}
	</script>
	
</body>
</html>
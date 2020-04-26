<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Date Time Picker Reference -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/momentjs/2.14.1/moment.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/css/bootstrap-datetimepicker.min.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<!-- Bootstrap Table Sorting Reference -->
<link
	href="https://unpkg.com/bootstrap-table@1.16.0/dist/bootstrap-table.min.css"
	rel="stylesheet">
<script
	src="https://unpkg.com/bootstrap-table@1.16.0/dist/bootstrap-table.min.js"></script>

<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">
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
					<button class="btn btn-secondary dropdown-toggle" type="button" id="originStationDropdown" data-toggle="dropdown">Origin Station</button>
					<ul class="dropdown-menu originStationFilter">
						<input class="form-control" id="originStationFilter" type="text" placeholder="Search..">
						<%
							for (String stationName : stationNames) {
						%>
						<li><button class="dropdown-item" type="button"
								onclick="dropdownSelect('originStation', '<%=stationName%>')">
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
					<button class="btn btn-secondary dropdown-toggle" type="button" id="arrivalStationDropdown" data-toggle="dropdown">Arrival Station</button>
					<ul class="dropdown-menu arrivalStationFilter">
						<input class="form-control" id="arrivalStationFilter" type="text" placeholder="Search..">
						<%
							for (String stationName : stationNames) {
						%>
						<li><button class="dropdown-item" type="button" onclick="dropdownSelect('arrivalStation', '<%=stationName%>')">
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
					<button class="btn btn-secondary dropdown-toggle" type="button" id="originStationDropdown" data-toggle="dropdown"> Date Filter</button>
					<ul class="dropdown-menu dateFilter">
						<input class="form-control" id="dateFilter" type="text" placeholder="Search..">
						<%
							for (String stationName : stationNames) {
						%>
						<li><button class="dropdown-item" type="button"
								onclick="dropdownSelect('originStation', '<%=stationName%>')">
								<%=stationName%>
							</button></li>
						<%
							}
						%>
					</ul>
				</div>
			</div>
			
			<!-- Date Filter Button -->
			<div class="col">
				<div class="mt-4">
					<button class="btn btn-primary" type="button" id="checkScheduleBtn">Check Schedule</button>
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
				
			window.history.replaceState({}, 'Train Schedule View', 'scheduleView.jsp?'+urlParams);
			location.reload();
		}
		
		function dropdownSelect(filterGroup, filterValue) {				
			//console.log("dropdownSelect(): filterGroup = " + filterGroup + ", filterValue = " + filterValue);
			// Change button text to be selected value and change color
			if(filterValue != 'all') {
				document.getElementById(filterGroup + "Dropdown").innerHTML = filterValue;
				document.getElementById(filterGroup + "Dropdown").classList.remove("btn-secondary");
				document.getElementById(filterGroup + "Dropdown").classList.add("btn-primary");
			}
			
			//buildURL(filterGroup, filterValue);
		}
	</script>
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
		integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN"
		crossorigin="anonymous"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
		integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q"
		crossorigin="anonymous"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
		integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl"
		crossorigin="anonymous"></script>
</body>
</html>
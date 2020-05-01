<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<!-- Bootstrap CSS Reference -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
	
	<meta charset="UTF-8">
	<title>Landing Page</title>
</head>
<body>

<%@ page import="java.sql.*"%>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
	Statement st = con.createStatement();
	ResultSet rs;
	String userName = null, userStatus = null;

	if ((session.getAttribute("BaseUser") == null)) { %>
		<!-- No user account is logged in -->
		You are not logged in<br/>
		<a href="index.jsp">Please Login</a>
		<% return;
	} 
	else {
		userName = (String) session.getAttribute("BaseUser");
		String query = "SELECT * FROM Customer WHERE username='" + userName + "'";
		rs = st.executeQuery(query);
		
		if (!(rs.next())) {
		    String admQuery = "SELECT * FROM Administrator WHERE admUsername='" + userName + "'";
		    rs = st.executeQuery(admQuery);
		    if (!(rs.next())) {
		        String empQuery = "SELECT * FROM Employee WHERE empUsername='" + userName + "'";
		    	rs = st.executeQuery(empQuery);
		    	if (!(rs.next())) {%>
					You do not have an associated role, please contact the administrator<br/>
					<a href="index.jsp">Go back to login</a>
				<%}
		    	else
		    		userStatus = "Employee";
			}
		    else
				userStatus = "Admin";
		} 
		else
			userStatus = "Customer";
	}
%>

<div class="container">
	<div class="row mt-4">
		<!-- Display user name and logout button -->
		<div class="col-sm">
			<label class="control-label">Welcome <%=userName%></label>
			<button type="button" class="btn btn-outline-primary" onclick="logoutBtnClick()">Logout</button>
		</div>
		
		<!-- Display user status -->
		<div class="col-sm text-right">
			<label class="control-label">User Status: <%=userStatus%></label>
		</div>
	</div>
	
	<!-- "Search Schedules" Button -->
	<div class="row mt-4">
		<div class="col-sm"></div>
		<div class="col-sm">
			<div class="text-center">
				<button type="button" class="btn btn-primary" onclick="searchSchedulesBtnClick()">Search Train Schedules</button>
			</div>
		</div>
		<div class="col-sm"></div>
	</div>
	
	<%if(userStatus == "Customer") {
		// Display Customer Actions%>
		<label class="control-label mt-4">Customer Actions:</label>
		<div class="border">
		<div class="row my-4">
			<!-- "Make Reservation" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="makeReservationBtnClick()">Make a Reservation</button>
				</div>
			</div>
			
			<!-- "View My Reservations" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="viewReservationsBtnClick()">View My Reservations</button>
				</div>
			</div>
			
			<!-- "Message Center" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="msgCenterBtnClick()">Message Center</button>
				</div>
			</div>
		</div>
		</div> <%
	}
	else if(userStatus == "Employee") {
		// Display Sales Rep Actions%>
		<label class="control-label mt-4">Sales Representative Actions:</label>
		<div class="border">
		<div class="row my-4">
			<!-- "Modify Schedules" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="modifySchedulesBtnClick()">Modify Schedules</button>
				</div>
			</div>
			
			<!-- "Advanced Lists" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="advancedListsBtnClick()">Advanced Lists</button>
				</div>
			</div>
		</div>
		</div><%
	}
	else {
		// Display admin actions %>
		<label class="control-label mt-4">Admin Actions:</label>
		<div class="border">
		<div class="row my-4">
			<!-- "Sales Report" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="salesReportBtnClick()">Sales Report</button>
				</div>
			</div>
			
			<!-- "Revenue Report" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="revenueReportBtnClick()">Revenue Report</button>
				</div>
			</div>
			
			<!-- "Reservation Report" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="reservationReportBtnClick()">Reservation Report</button>
				</div>
			</div>
			
			<!-- "Best Customer" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="bestCustomerBtnClick()">Best Customer</button>
				</div>
			</div>
			
			<!-- "Best Lines" Button -->
			<div class="col-sm">
				<div class="text-center">
					<button type="button" class="btn btn-primary" onclick="bestLinesBtnClick()">Best Lines</button>
				</div>
			</div>
		</div>
		</div><%
	}%>	
</div>

<script>
	var userType = '<%=userStatus%>';		// pass variable from jsp to js, to be used to check if user can access button click
	
	function logoutBtnClick() {
		window.location.assign("logout.jsp");
	}

	function searchSchedulesBtnClick() {
		window.location.assign("scheduleViewHome.jsp");
	}
	
	/* 
	* Customer Button Functions 
	*/
	function makeReservationBtnClick() {
		window.location.assign("reservation.jsp");
	}
	
	function viewReservationsBtnClick() {
	    window.location.assign("reservationList.jsp");
	}
	
	function msgCenterBtnClick() {
		window.location.assign("messenger/messageIndex.jsp");
	}
	
	/* 
	* Sales Representative Button Functions 
	*/
	function modifySchedulesBtnClick() {
		// TODO: Assign proper URL
	}
	
	function advancedListsBtnClick() {
		// TODO: Assign proper URL
	}
	
	/* 
	* Admin Button Functions 
	*/
	function salesReportBtnClick() {
		window.location.assign("salesReport.jsp");
	}
	
	function revenueReportBtnClick() {
		window.location.assign("listOfRevenue.jsp");
	}
	
	function reservationReportBtnClick() {
		window.location.assign("listOfReservations.jsp");
	}
	
	function bestCustomerBtnClick() {
		window.location.assign("customerRevenue.jsp");
	}
	
	function bestLinesBtnClick() {
		window.location.assign("mostActive.jsp");
	}
</script>

<!-- Bootstrap JS Reference -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
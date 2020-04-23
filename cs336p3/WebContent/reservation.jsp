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
		private int origin;
		private int arrival;
		private String line;
		
		Departure(int depId, int origin, int arrival, String line) {
			super();
			this.depId = depId;
			this.origin = origin;
			this.arrival = arrival;
			this.line = line;
		}
		
		int getId() {
			return this.depId;
		}
		
		int getOrigin() {
			return this.origin;
		}
		
		int getArrival() {
			return this.arrival;
		}
		
		String getLine() {
			return this.line;
		}
	}
	
	class Station {
		private String name;
		private int stationId;
		private String city;
		
		Station(String name, int stationId, String city) {
			this.name = name;
			this.stationId = stationId;
			this.city = city;
		}
		
		String getName() {
			return this.name;
		}
		
		int getStationId() {
			return this.stationId;
		}
		
		String getCity() {
			return this.city;
		}
	}
	
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://cs336db.czhkagzhmas1.us-east-2.rds.amazonaws.com:3306/trainProject","admin", "s1gnINadmin");
    Statement st = con.createStatement();
    ResultSet rs;
    
    out.println(session.getAttribute("BaseUser"));
    
    rs = st.executeQuery("SELECT * FROM Departures"); 
   
    List<Departure> dep = new ArrayList<Departure>();
    
    while(rs.next()) {
    	int depId = rs.getInt("dep_id");
    	int origin = rs.getInt("origin_id");
    	int arrival = rs.getInt("arrival_id");
    	String line = rs.getString("line_name");
    	Departure temp = new Departure(depId, origin, arrival, line);
    	dep.add(temp);
    }
    
    rs = st.executeQuery("SELECT * FROM Station");
   
    List<Station> stations = new ArrayList<Station>();
    
    while(rs.next()) {
    	String name = rs.getString("name");
    	int stationId= rs.getInt("station_id");
    	String city = rs.getString("city");
   		Station temp = new Station(name, stationId, city);
   		stations.add(temp);
    }
    
    String data = "Hello!";
%>

<form class="ui large form" action="checkLoginDetails.jsp" method="POST">
		      <div class="ui stacked segment">
		      	  <div>
		          	 Select train line:&nbsp;
		         	 <select name="line">
		         	 <% 
		         	 for (Departure d : dep) {
		         	 	%><option value=<% d.getId(); %>><% out.println(d.getLine()); %></option>
		         	 <% }
		         	 %>
		         	 </select>
		          </div>
		          <div>
		          	 Select station of departure:&nbsp;
		         	 <select name="origin">
		         	 <% 
		         	 for (Departure d : dep) {
		         	 	%><option value=<% d.getId(); %>><% out.println(d.getOrigin()); %></option>
		         	 <% }
		         	 %>
		         	 </select>
		          </div>
		          <div>
		          	 Select station of arrival:&nbsp;
		          	 <select name="arrival">
		          	 <% 
		         	 for (Departure d : dep) {
		         	 	%><option value=<% d.getId(); %>><% out.println(d.getArrival()); %></option>
		         	 <% }
		         	 %>
		         	 </select>
		          </div>
		       <input type="submit" value="Submit" name="bt1"/>
		      </div>
		      </form>

</body>
</html>
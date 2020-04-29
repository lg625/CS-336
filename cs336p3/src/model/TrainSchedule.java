package model;

public class TrainSchedule {
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
	
	// Get urlParameter input and convert to become readable for an SQL query
	public static String createSQLStatement(String urlParameters) {
		/*String output = "SELECT t.stops, t.startDepartureTime, t.endArrivalTime, t.travelTime, t.travelDate, t.transitLine, s1.name as startStation, s2.name as endStation " + 
						"FROM TrainSchedule t " +
						"LEFT OUTER JOIN Station s1 ON t.startStation = s1.station_id " + 
						"LEFT OUTER JOIN Station s2 ON t.endStation = s2.station_id";*/
		
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

package model;

public class TrainSchedule {
	public String transitLine, numStops, originStation, arrivalStation, arrivalTime, deptTime, totalTime, date_dep;
	
	public TrainSchedule(String transitLine, String numStops, String originStation, String arrivalStation, String arrivalTime, String deptTime, String totalTime, String date_dep) {
		this.transitLine = transitLine;
		this.numStops = numStops;
		this.originStation = originStation;
		this.arrivalStation = arrivalStation;
		this.arrivalTime = arrivalTime;
		this.deptTime = deptTime;
		this.totalTime = totalTime;
		this.date_dep = date_dep;
	}
	
	// Get urlParameter input and convert to become readable for an SQL query
	public static String createSQLStatement(String urlParameters) {
		/*String output = "SELECT t.stops, t.startDepartureTime, t.endArrivalTime, t.travelTime, t.travelDate, t.transitLine, s1.name as startStation, s2.name as endStation " + 
						"FROM TrainSchedule t " +
						"LEFT OUTER JOIN Station s1 ON t.startStation = s1.station_id " + 
						"LEFT OUTER JOIN Station s2 ON t.endStation = s2.station_id";*/
		
		String output = "SELECT s1.name as originStation, s2.name as arrivalStation, d.date_dep, d.departs, d.arrives, d.line_name, d.train_id " + 
						"FROM Departures d " + 
						"LEFT OUTER JOIN Station s1 on d.origin_id = s1.station_id " + 
						"LEFT OUTER JOIN Station s2 on d.arrival_id = s2.station_id";
		
		// example input: transitLine=NorthEast+Corridor
		if(urlParameters.length() == 0 || urlParameters == null)
			return output;
		else {
			output = output.concat(" HAVING ");
			String[] parameters = urlParameters.split("&");
			
			// go through each parameter and append to output string
			for(int i = 0; i < parameters.length; i++) {
				String parameter[] = parameters[i].split("=");
				
				// check if parameter value has any spaces
				if(parameter[1].contains("+") || parameter[1].contains("-")) {
					parameter[1] = parameter[1].replace("+", " ");
					parameter[1] = "'" + parameter[1] + "'";
				}
				
				//System.out.println("parameter: " + parameter[0] + " = " + parameter[1]);
				if(i != 0)
					output = output.concat(" AND ");
				
				output = output.concat(parameter[0] + " = " + parameter[1]);
			}
		}
		
		return output;
	}
	
	public static void main(String args[])  {
		//System.out.println(createSQLStatement("transitLine=NorthEast+Corridor&groupVal=Testing+color+red"));
		//System.out.println(createSQLStatement(""));
	}
}

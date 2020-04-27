package model;

public class TrainSchedule {
	public String transitLine, numStops, origin_name, arrival_name, arrivalTime, deptTime, totalTime, date_dep, total_fare;
	
	public TrainSchedule(String transitLine, String numStops, String originStation, String arrivalStation, String deptTime, String arrivalTime, String totalTime, String date_dep, String total_fare) {
		this.transitLine = transitLine;
		this.numStops = numStops;
		this.origin_name = originStation;
		this.arrival_name = arrivalStation;
		this.arrivalTime = arrivalTime;
		this.deptTime = deptTime;
		this.totalTime = totalTime;
		this.date_dep = date_dep;
		this.total_fare = total_fare;
	}
	
	// Get urlParameter input and convert to become readable for an SQL query
	public static String createSQLStatement(String urlParameters) {		
		String output = "SELECT * FROM full_departures";
		
		// example input: transitLine=NorthEast+Corridor
		if(urlParameters.length() == 0 || urlParameters == null)
			return output;
		else {
			output = output.concat(" WHERE ");
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

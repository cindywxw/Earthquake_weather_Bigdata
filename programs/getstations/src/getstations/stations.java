package getstations;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;

public class stations {
	public static void main(String[] args) {
	    try {
	        BufferedReader in = new BufferedReader(new FileReader("/media/sf_share/project/WorldwideStationList.html"));
	        PrintWriter out = new PrintWriter("/media/sf_share/project/stations.txt", "UTF-8");
	        String str;
	        int line = 0;
	        int rec = 0;
	        while ((str = in.readLine()) != null) {
	        	line++;
	        	String name = "NA";
	            if (line >= 21) {
	            	if (str.charAt(0) < '0' || str.charAt(0) > '9') break;
	            	if (str.charAt(7) == ' ') {
//	            		System.out.println(str);
	            		name = "";
	            	}
	            	if (str.charAt(str.length() - 8) == ' '|| str.charAt(str.length() - 8) == '-') {
	            		if (str.charAt(str.length() - 8) == '-') {
	            			str = str.substring(0, str.length() - 8) + " " + str.substring(str.length() - 7);
	            		}
		            	String[] contents = str.split("\\s+");
		            	int n = contents.length;
		            	if(contents[n-1].equals("00000") || contents[n-1].equals("**")) continue;
		            	rec++;
		            	if (name.equals("NA")) name = contents[1];
		            	String lat = contents[n-3];
		            	String lon = contents[n-2];
		            	String country = contents[n-4];
		            	if (country.length() != 2) country = "NA";
		            	Double latN, lonN;
	            		if (lat.endsWith("N")) {
	            			latN = Double.parseDouble(lat.substring(0, lat.length() - 1))/100;
//	            			System.out.print("LAT: " + latN);
	            		} else {
	            			latN = 0 - Double.parseDouble(lat.substring(0, lat.length() - 1))/100;
//	            			System.out.print("LAT: " + latN);
	            		}
	            		if (lon.endsWith("E")) {
	            			lonN = Double.parseDouble(lon.substring(0, lon.length() - 1))/100;
//	            			System.out.println(" LON: " + lonN);
	            		} else {
	            			lonN = 0 - Double.parseDouble(lon.substring(0, lon.length() - 1))/100;
//	            			System.out.println(" LON: " + lonN);
	            		}
	            		out.println(contents[0]+ "," + name + "," + latN + "," + lonN  + "," + country);
	            	} else {
	            		String[] contents = str.split("\\s+");
		            	int n = contents.length;
		            	if(contents[n-1].equals("00000") || contents[n-1].equals("**")) continue;
		            	rec++;
		            	if (name.equals("NA")) name = contents[1];
		            	String lat = contents[n-2];
		            	String lon = contents[n-1];
		            	String country = contents[n-3];
		            	if (country.length() != 2) country = "NA";
		            	Double latN, lonN;
	            		if (lat.endsWith("N")) {
	            			latN = Double.parseDouble(lat.substring(0, lat.length() - 1))/100;
//	            			System.out.print("LAT: " + latN);
	            		} else {
	            			latN = 0 - Double.parseDouble(lat.substring(0, lat.length() - 1))/100;
//	            			System.out.print("LAT: " + latN);
	            		}
	            		if (lon.endsWith("E")) {
	            			lonN = Double.parseDouble(lon.substring(0, lon.length() - 1))/100;
//	            			System.out.println(" LON: " + lonN);
	            		} else {
	            			lonN = 0 - Double.parseDouble(lon.substring(0, lon.length() - 1))/100;
//	            			System.out.println(" LON: " + lonN);
	            		}
	            		out.println(contents[0]+ "," + name + "," + latN + "," + lonN  + "," + country);
	            	}
//	            	System.out.println(line);
	            }
	        }
            System.out.println(line);
            System.out.println(rec);
	        in.close();
	        out.close();
	    } catch (IOException e) {
	    }
	}
}

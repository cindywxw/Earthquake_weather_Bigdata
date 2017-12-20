package edu.uchicago.cindywen.apiearthquake;

import java.net.Authenticator;
import java.net.InetAddress;
import java.net.PasswordAuthentication;
import java.time.Instant;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Random;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Invocation;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.glassfish.jersey.jackson.JacksonFeature;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import edu.uchicago.cindywen.apiearthquake.EarthquakeResponse.Earthquake;
import edu.uchicago.cindywen.apiearthquake.WeatherResponse;


// Inspired by http://stackoverflow.com/questions/14458450/what-to-use-instead-of-org-jboss-resteasy-client-clientrequest
public class LatestEarthquakes {
	static class Task extends TimerTask {
		private Client client;
		Random generator = new Random();

		public EarthquakeResponse getEarthquakeResponse() {
			Invocation.Builder bldr
			  = client.target("https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson").request("application/json");
			try {
//				System.out.println(bldr.get());
				return bldr.get(EarthquakeResponse.class);
			} catch (Exception e) {
				System.err.println(e.getMessage());
			}
			return null;  // Sometimes the web service fails due to network problems. Just let it try again
		}

		public WeatherResponse getWeatherResponse(double lat, double lon) {
			Invocation.Builder bldr
			  = client.target("http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon="+ lon
			  		+"&APPID=4a8b3faa21fba84c4deee902ea914482").request("application/json");
			try {
				return bldr.get(WeatherResponse.class);
			} catch (Exception e) {
				System.err.println(e.getMessage());
			}
			return null;  // Sometimes the web service fails due to network problems. Just let it try again
		}

		// Adapted from http://hortonworks.com/hadoop-tutorial/simulating-transporting-realtime-events-stream-apache-kafka/
		Properties props = new Properties();
		String TOPIC = "earthquake";
		KafkaProducer<String, String> producer;
		
		public Task() {
			client = ClientBuilder.newClient();
			// enable POJO mapping using Jackson - see
			// https://jersey.java.net/documentation/latest/user-guide.html#json.jackson
			client.register(JacksonFeature.class); 
			props.put("bootstrap.servers", bootstrapServers);
			props.put("acks", "all");
			props.put("retries", 0);
			props.put("batch.size", 16384);
			props.put("linger.ms", 1);
			props.put("buffer.memory", 33554432);
			props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
			props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

			producer = new KafkaProducer<>(props);
		}

		@Override
		public void run() {
			EarthquakeResponse response = getEarthquakeResponse();
			if(response == null || response.getEarthquake() == null)
				return;
			ObjectMapper mapper = new ObjectMapper();

			for(Earthquake eq : response.getEarthquake()) {
				ProducerRecord<String, String> data;
				try {
					String id = eq.getId();
					Earthquake.Properties properties = eq.getProperties();
					Earthquake.Geometry geometry = eq.getGeometry();
					double lon = geometry.getCoord()[0];
					double lat = geometry.getCoord()[1];
					double dep = geometry.getCoord()[2];
					double mag = properties.getMag();
//					int sig = properties.getSig();
					String time = properties.getTime();
					String instant = Instant.ofEpochMilli(Long.parseLong(time)).toString();
					int year = Integer.parseInt(instant.substring(0,4));
					int month = Integer.parseInt(instant.substring(5,7));
					int day = Integer.parseInt(instant.substring(8,10));
//					System.out.println(id+","+instant+","+lat+","+lon+","+dep+","+mag);
//					Boolean fog = false, rain = false, snow = false, hail = false, thunder = false, tornado = false, clear = false;
					int fog = 0, rain = 0, snow = 0, hail = 0, thunder = 0, tornado = 0, clear = 0;
					double temp = 0;
					String country = "NA";
					String weather = "clear";
					WeatherResponse wr = getWeatherResponse(lat, lon);
					if(wr == null || wr.getWeather() == null ||
							wr.getMain() == null || wr.getSys() == null) {
						System.out.println("blank");
					} else {
						WeatherResponse.Weather w = wr.getWeather()[0];
						temp = wr.getMain().getTemp() - 273.15;
						country = wr.getSys().getCountry();
//						System.out.println(w.getMain());
						if (w.getMain().contains("Mist"))  {fog = 1; weather = "fog";}
						else if (w.getMain().contains("Rain")) {rain = 1; weather = "rain";}
						else if (w.getMain().contains("Snow")) {snow = 1; weather = "snow";}
						else if (w.getMain().contains("Hail")) {hail = 1; weather = "hail";}
						else if (w.getMain().contains("Thunder")) {thunder = 1; weather = "thunder";}
						else if (w.getMain().contains("Tornado")) {tornado = 1; weather = "tornado";}
						else {clear = 1; weather = "clear";}
					}
//					System.out.println(id+""+fog+""+rain+""+snow
//							+""+hail+""+thunder+""+tornado+""+clear + ","+ temp+""+weather+""+country);
					
//					KafkaEarthquakeWeatherRecord kfr = new KafkaEarthquakeWeatherRecord(
//							country, 1,dep, temp, mag, 
//							fog, rain, snow, hail, thunder, tornado, clear);
					KafkaEarthquakeRecord kfr = new KafkaEarthquakeRecord(
							id, instant, year, month, day, lat, lon, dep, mag, temp, country,
							fog, rain, snow, hail, thunder, tornado, clear);
					data = new ProducerRecord<String, String>
					(TOPIC, 
					 mapper.writeValueAsString(kfr));
					producer.send(data);
				} catch (JsonProcessingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}

	}
	public static class CustomAuthenticator extends Authenticator {

		// Called when password authorization is needed
		protected PasswordAuthentication getPasswordAuthentication() {

			// Get information about the request
			String prompt = getRequestingPrompt();
			String hostname = getRequestingHost();
			InetAddress ipaddr = getRequestingSite();
			int port = getRequestingPort();

			String username = "cindywen"; // TODO
			String password = "4a8b3faa21fba84c4deee902ea914482"; // TODO

			// Return the information (a data holder that is used by Authenticator)
			return new PasswordAuthentication(username, password.toCharArray());

		}

	}

	static String bootstrapServers = new String("10.0.0.2:6667");

	public static void main(String[] args) {
		if(args.length > 0)  // This lets us run on the cluster with a different kafka
			bootstrapServers = args[0];
		Authenticator.setDefault(new CustomAuthenticator());
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new Task(), 0, 60*1000);
	}
}


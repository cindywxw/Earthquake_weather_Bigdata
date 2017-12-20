package edu.uchicago.cindywen.apiearthquake;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
class WeatherResponse {
	@JsonIgnoreProperties(ignoreUnknown = true)
	static class Weather {
//		public Weather() {}
		public int getIdent() {
			return id;
		}
		public void setIdent(int id) {
			this.id = id;
		}		
		public String getMain() {
			return main;
		}
		public void setMain(String main) {
			this.main = main;
		}
		public String getDescription() {
			return desc;
		}
		public void setDescription(String desc) {
			this.desc = desc;
		}
		@JsonProperty("id")
		private int id;
		@JsonProperty("main")
		private String main;
		@JsonProperty("description")
		private String desc;
	}
	
	@JsonIgnoreProperties(ignoreUnknown = true)
	static class Main {
		public double getTemp() {
			return temp;
		}
		public void setTemp(double temp) {
			this.temp = temp;
		}
		public double getMinTemp() {
			return min_temp;
		}
		public void setMinTemp(double min_temp) {
			this.min_temp = min_temp;
		}
		public double getMaxTemp() {
			return max_temp;
		}
		public void setMaxTemp(double max_temp) {
			this.max_temp = max_temp;
		}
		@JsonProperty("temp")
		private double temp;
		@JsonProperty("temp_max")
		private double max_temp;
		@JsonProperty("temp)min")
		private double min_temp;
		
	}
	@JsonIgnoreProperties(ignoreUnknown = true)
	static class Sys {
		public String getCountry() {
			return country;
		}
		public void setCountry(String country) {
			this.country = country;
		}
		@JsonProperty("country")
		private String country;
		
	}
	
	public Weather[] getWeather() {
		return weather;
	}
	public void setWeather(Weather[] weather) {
		this.weather = weather;
	}
	public Main getMain() {
		return main;
	}
	public void setMain(Main main) {
		this.main = main;
	}
	public Sys getSys() {
		return sys;
	}
	public void setSys(Sys sys) {
		this.sys = sys;
	}
	@JsonProperty("weather")
	private Weather[] weather;
	@JsonProperty("main")
	private Main main;
	@JsonProperty("sys")
	private Sys sys;

}

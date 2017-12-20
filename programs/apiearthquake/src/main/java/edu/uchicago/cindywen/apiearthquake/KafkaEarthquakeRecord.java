package edu.uchicago.cindywen.apiearthquake;

public class KafkaEarthquakeRecord {
	public KafkaEarthquakeRecord(String id, String time, int year, int month, int day,
			double lat, double lon, double dep, double mag, double temp, String country,
			int fog, int rain, int snow, int hail, int thunder, int tornado, int clear) {
		super();
		this.id = id;
		this.time = time;
		this.year = year;
		this.month = month;
		this.day = day;
		this.lat = lat;
		this.lon = lon;
		this.dep = dep;
		this.mag = mag;
		this.temp = temp;
		this.country = country;
		this.fog = fog;
		this.rain = rain;
		this.snow = snow;
		this.hail = hail;
		this.thunder = thunder;
		this.tornado = tornado;
		this.clear = clear;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public int getYear() {
		return year;
	}
	public void setYear(int year) {
		this.year = year;
	}
	public int getMonth() {
		return month;
	}
	public void setMonth(int month) {
		this.month = month;
	}
	public int getDay() {
		return day;
	}
	public void setDay(int day) {
		this.day = day;
	}
	public double getLat() {
		return lat;
	}
	public void setLat(double lat) {
		this.lat = lat;
	}
	public double getLon() {
		return lon;
	}
	public void setLon(double lon) {
		this.lon = lon;
	}
	public double getDep() {
		return dep;
	}
	public void setDep(double dep) {
		this.dep = dep;
	}
	public double getMag() {
		return mag;
	}
	public void setMag(double mag) {
		this.mag = mag;
	}
	public double getTemp() {
		return temp;
	}
	public void setTemp(double temp) {
		this.temp = temp;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public int getFog() {
		return fog;
	}
	public void setFog(int fog) {
		this.fog = fog;
	}
	public int getRain() {
		return rain;
	}
	public void setRain(int rain) {
		this.rain = rain;
	}
	public int getSnow() {
		return snow;
	}
	public void setSnow(int snow) {
		this.snow = snow;
	}
	public int getHail() {
		return hail;
	}
	public void setHail(int hail) {
		this.hail = hail;
	}
	public int getThunder() {
		return thunder;
	}
	public void setThunder(int thunder) {
		this.thunder = thunder;
	}
	public int getTornado() {
		return tornado;
	}
	public void setTornado(int tornado) {
		this.tornado = tornado;
	}
	public int getClear() {
		return clear;
	}
	public void setClear(int clear) {
		this.clear = clear;
	}

	String id;
	String time;
	int year;
	int month;
	int day;
	double lat;
	double lon;
	double dep;
	double mag;
	double temp;
	String country;
	int fog;
	int rain;
	int snow;
	int hail;
	int thunder;
	int tornado;
	int clear;
}

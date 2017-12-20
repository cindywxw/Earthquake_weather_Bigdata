package edu.uchicago.cindywen.apiearthquake;

public class KafkaEarthquakeWeatherRecord {
	public KafkaEarthquakeWeatherRecord(String country, int count, double depth, double temp, double mag, 
			int fog, int rain, int snow, int hail, int thunder, int tornado, int clear) {
		super();
		this.country = country;
		this.count = count;
		this.depth = depth;
		this.temp = temp;
		this.mag = mag;
		this.fog = fog;
		this.rain = rain;
		this.snow = snow;
		this.hail = hail;
		this.thunder = thunder;
		this.tornado = tornado;
		this.clear = clear;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public double getDepth() {
		return depth;
	}
	public void setDepth(double depth) {
		this.depth = depth;
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

	String country;
	int count;
	double depth;
	double mag;
	double temp;
	int fog;
	int rain;
	int snow;
	int hail;
	int thunder;
	int tornado;
	int clear;
}

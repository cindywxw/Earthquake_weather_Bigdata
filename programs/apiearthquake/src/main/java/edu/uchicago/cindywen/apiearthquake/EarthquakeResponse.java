package edu.uchicago.cindywen.apiearthquake;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
class EarthquakeResponse {
	@JsonIgnoreProperties(ignoreUnknown = true)
	static class Earthquake {
//		public Earthquake() {}
		
		@JsonIgnoreProperties(ignoreUnknown = true)
		static class Properties {
			public double getMag() {
				return mag;
			}
			public void setMag(double mag) {
				this.mag = mag;
			}
			public String getPlace() {
				return place;
			}
			public void setPlace(String place) {
				this.place = place;
			}
			public void setTime(String time) {
				this.time = time;
			}
			public String getTime() {
				return time;
			}
			public void setSig(int sig) {
				this.sig = sig;
			}
			public int getSig() {
				return sig;
			}
//			public void setStatus(String status) {
//				this.status = status;
//			}
//			public String getStatus() {
//				return status;
//			}
//			public void setNet(String net) {
//				this.net = net;
//			}
//			public String getNet() {
//				return net;
//			}
//			public void setNst(int nst) {
//				this.nst = nst;
//			}
//			public int getNst() {
//				return nst;
//			}
//			public Double getDmin() {
//				return dmin;
//			}
//			public void setDmin(Double dmin) {
//				this.dmin = dmin;
//			}
//			public Double getRms() {
//				return rms;
//			}
//			public void setRms(Double rms) {
//				this.rms = rms;
//			}
//			public void setGap(int gap) {
//				this.gap = gap;
//			}
//			public int getGap() {
//				return gap;
//			}
//			public void setMagType(String magType) {
//				this.magType = magType;
//			}
//			public String getMagType() {
//				return magType;
//			}
//			public void setType(String type) {
//				this.type = type;
//			}
//			public String getType() {
//				return type;
//			}
			
			@JsonProperty("mag")
			private double mag;			
			@JsonProperty("place")
			private String place;
			@JsonProperty("time")
			private String time;
			@JsonProperty("sig")
			private int sig;
//			@JsonProperty("status")
//			private String status;
//			@JsonProperty("net")
//			private String net;
//			@JsonProperty("type")
//			private String type;
//			@JsonProperty("nst")
//			private int nst;
//			@JsonProperty("dmin")
//			private double dmin;
//			@JsonProperty("rms")
//			private double rms;
//			@JsonProperty("gap")
//			private int gap;
//			@JsonProperty("magType")
//			private String magType;
		}
		
		@JsonIgnoreProperties(ignoreUnknown = true)
		static class Geometry {
			public double[] getCoord() {
				return coord;
			}
			public void setCoord(double[] coord) {
				this.coord = coord;
			}

			@JsonProperty("coordinates")
			private double[] coord;
			
		}
		
		public Properties getProperties() {
			return prop;
		}
		public void setProperties(Properties prop) {
			this.prop = prop;
		}
//		public String getDescription() {
//			return desc;
//		}
//		public void setDescription(String desc) {
//			this.desc = desc;
//		}
		
		@JsonProperty("properties")
		private Properties prop;
//		@JsonProperty("description")
//		private String desc;
		
		public Geometry getGeometry() {
			return geometry;
		}
		public void setGeometry(Geometry geometry) {
			this.geometry = geometry;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {				
			this.id = id;
		}
		@JsonProperty("geometry")
		private Geometry geometry;
//		@JsonProperty("sys")
//		private Sys sys;
		@JsonProperty("id")
		private String id;
	}
	
		
	
	public Earthquake[] getEarthquake() {
		return earthquake;
	}
	public void setEarthquake(Earthquake[] earthquake) {
		this.earthquake = earthquake;
	}
	
//	public Main getMain() {
//		return main;
//	}
//	public void setMain(Main main) {
//		this.main = main;
//	}
//	public Sys getSys() {
//		return sys;
//	}
//	public void setSys(Sys sys) {
//		this.sys = sys;
//	}
	@JsonProperty("features")
	private Earthquake[] earthquake;
	
}

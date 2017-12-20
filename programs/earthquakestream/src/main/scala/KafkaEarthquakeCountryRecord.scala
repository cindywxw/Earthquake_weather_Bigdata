import scala.reflect.runtime.universe._


case class KafkaEarthquakeCountryRecord(
    country: String,
    count: Long = 0,
    depth: Double = 0.0,
    temp: Double = 0.0,
    mag: Double = 0.0,
    fog: Long = 0,
    rain: Long = 0,
    snow: Long = 0,
    hail: Long = 0,
    thunder: Long = 0,
    tornado: Long = 0,
    clear: Long = 0) {
    def +(that: KafkaEarthquakeCountryRecord) = new KafkaEarthquakeCountryRecord (
        this.country,
        this.count + that.count,
        this.depth + that.depth,
        this.temp + that.temp,
        this.mag + that.mag,
        this.fog + that.fog,
        this.rain + that.rain,
        this.snow + that.snow,
        this.hail + that.hail,
        this.thunder + that.thunder,
        this.tornado + that.tornado,
        this.clear + that.clear)
}

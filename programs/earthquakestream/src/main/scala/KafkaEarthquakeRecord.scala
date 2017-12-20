import scala.reflect.runtime.universe._


case class KafkaEarthquakeRecord(
    id: String,
    time: String,
    year: Int,
    month: Int,
    day: Int,
    lat: Double, 
    lon: Double,
    dep: Double,
    mag: Double,
    temp: Double,
    country: String = "NA",
    fog: Long,
    rain: Long,
    snow: Long,
    hail: Long,
    thunder: Long,
    tornado: Long,
    clear: Long)

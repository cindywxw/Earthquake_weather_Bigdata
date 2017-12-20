import kafka.serializer.StringDecoder
import kafka.common.TopicAndPartition


import org.apache.spark.streaming._
import org.apache.spark.streaming.dstream.DStream
import org.apache.spark.streaming.kafka._
import org.apache.spark.SparkConf
import com.fasterxml.jackson.databind.{ DeserializationFeature, ObjectMapper }
import com.fasterxml.jackson.module.scala.experimental.ScalaObjectMapper
import com.fasterxml.jackson.module.scala.DefaultScalaModule
import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.hbase.TableName
import org.apache.hadoop.hbase.HBaseConfiguration
import org.apache.hadoop.hbase.client.ConnectionFactory
import org.apache.hadoop.hbase.client.Get
import org.apache.hadoop.hbase.client.Put
import org.apache.hadoop.hbase.util.Bytes


object StreamData {
  val mapper = new ObjectMapper()
  mapper.registerModule(DefaultScalaModule)
  val hbaseConf: Configuration = HBaseConfiguration.create()
  hbaseConf.set("hbase.zookeeper.property.clientPort", "2181")
  
  // Use the following two lines if you are building for the cluster 
   hbaseConf.set("hbase.zookeeper.quorum","mpcs530132017test-hgm1-1-20170924181440.c.mpcs53013-2017.internal,mpcs530132017test-hgm2-2-20170924181505.c.mpcs53013-2017.internal,mpcs530132017test-hgm3-3-20170924181529.c.mpcs53013-2017.internal")
   hbaseConf.set("zookeeper.znode.parent", "/hbase-unsecure")
  
  // Use the following line if you are building for the VM
//  hbaseConf.set("hbase.zookeeper.quorum", "localhost")
  
  val hbaseConnection = ConnectionFactory.createConnection(hbaseConf)
  val table = hbaseConnection.getTable(TableName.valueOf("xw_earthquakeweather_by_country_speed"))
  val rawTable = hbaseConnection.getTable(TableName.valueOf("xw_earthquakeweather_speed"))
  
  def main(args: Array[String]) {
    if (args.length < 1) {
      System.err.println(s"""
        |Usage: StreamData <brokers> 
        |  <brokers> is a list of one or more Kafka brokers
        | 
        """.stripMargin)
      System.exit(1)
    }

    val Array(brokers) = args

    // Create context with 10 second batch interval
    val sparkConf = new SparkConf().setAppName("StreamData")
    val ssc = new StreamingContext(sparkConf, Seconds(10))

    // Create direct kafka stream with brokers and topics
    val topicsSet = Set[String]("earthquake")
    val kafkaParams = Map[String, String]("metadata.broker.list" -> brokers)
    val messages = KafkaUtils.createDirectStream[String, String, StringDecoder, StringDecoder](
      ssc, kafkaParams, topicsSet)
    val serializedRecords = messages.map(_._2);
    val kfrs = serializedRecords.map(rec => mapper.readValue(rec, classOf[KafkaEarthquakeRecord]))
  

    // read from HBase table, insert, integrate and put data to HTable
    val batchStats = kfrs.map(kfr => {
    val result = rawTable.get(new Get(Bytes.toBytes(kfr.id)))
        if(result == null || result.getRow() == null) {
          val result2 = table.get(new Get(Bytes.toBytes(kfr.country)))
          if (result2 == null || result2.getRow() == null) {
            val put = new Put(Bytes.toBytes(kfr.country))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("count"), Bytes.toBytes("1".toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("depth"), Bytes.toBytes(kfr.dep.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("temp"), Bytes.toBytes(kfr.temp.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("mag"), Bytes.toBytes(kfr.mag.toString())) 
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("fog"), Bytes.toBytes(kfr.fog.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("rain"), Bytes.toBytes(kfr.rain.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("snow"), Bytes.toBytes(kfr.snow.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("hail"), Bytes.toBytes(kfr.hail.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("thunder"), Bytes.toBytes(kfr.thunder.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("tornado"), Bytes.toBytes(kfr.tornado.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("clear"),Bytes.toBytes(kfr.clear.toString()))
            table.put(put) 
        
            KafkaEarthquakeCountryRecord(kfr.country, 1, kfr.dep,  kfr.temp, kfr.mag,
                kfr.fog, kfr.rain, kfr.snow, kfr.hail, kfr.thunder, kfr.tornado, kfr.clear)
          } else {
            System.out.println(kfr.dep)
            System.out.println(Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("depth"))).toDouble)
            
            val b = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("depth"))).toDouble + kfr.dep
            val e = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("fog"))).toLong + kfr.fog
            val a = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("count"))).toLong + 1
            
            val c = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("temp"))).toDouble + kfr.temp
            val d = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("mag"))).toDouble + kfr.mag
            
            val f = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("rain"))).toLong + kfr.rain
            val g = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("snow"))).toLong + kfr.snow
            val h = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("hail"))).toLong + kfr.hail
            val i = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("thunder"))).toLong + kfr.thunder
            val j = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("tornado"))).toLong + kfr.tornado
            val k = Bytes.toString(result2.getValue(Bytes.toBytes("cnty"), Bytes.toBytes("clear"))).toLong + kfr.clear

            val put = new Put(Bytes.toBytes(kfr.country))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("count"), Bytes.toBytes(a.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("depth"), Bytes.toBytes(b.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("temp"), Bytes.toBytes(c.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("mag"), Bytes.toBytes(d.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("fog"), Bytes.toBytes(e.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("rain"), Bytes.toBytes(f.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("snow"), Bytes.toBytes(g.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("hail"), Bytes.toBytes(h.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("thunder"), Bytes.toBytes(i.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("tornado"),Bytes.toBytes(j.toString()))
            put.addColumn(Bytes.toBytes("cnty"), Bytes.toBytes("clear"), Bytes.toBytes(k.toString()))
            table.put(put) 
            KafkaEarthquakeCountryRecord(kfr.country, 1, kfr.dep, kfr.temp, kfr.mag,
              kfr.fog, kfr.rain, kfr.snow, kfr.hail, kfr.thunder, kfr.tornado, kfr.clear)
          }
            val put2 = new Put(Bytes.toBytes(kfr.id))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("time"), Bytes.toBytes(kfr.time.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("year"), Bytes.toBytes(kfr.year.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("month"), Bytes.toBytes(kfr.month.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("day"), Bytes.toBytes(kfr.day.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("latitude"), Bytes.toBytes(kfr.lat.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("longitude"), Bytes.toBytes(kfr.lon.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("depth"), Bytes.toBytes(kfr.dep.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("mag"), Bytes.toBytes(kfr.mag.toString())) 
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("temp"), Bytes.toBytes(kfr.temp.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("country"), Bytes.toBytes(kfr.country.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("fog"), Bytes.toBytes(kfr.fog.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("rain"), Bytes.toBytes(kfr.rain.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("snow"), Bytes.toBytes(kfr.snow.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("hail"), Bytes.toBytes(kfr.hail.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("thunder"), Bytes.toBytes(kfr.thunder.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("tornado"), Bytes.toBytes(kfr.tornado.toString()))
            put2.addColumn(Bytes.toBytes("eq"), Bytes.toBytes("clear"),Bytes.toBytes(kfr.clear.toString()))
            rawTable.put(put2)  
////            System.out.println("xw_earthquakeweather updated")
            KafkaEarthquakeCountryRecord(kfr.country, 1, kfr.dep, kfr.temp, kfr.mag,
              kfr.fog, kfr.rain, kfr.snow, kfr.hail, kfr.thunder, kfr.tornado, kfr.clear)
//            KafkaEarthquakeCountryRecord(kfr.country, 0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0)
       } else {
//         System.out.println("Existing record")
//         KafkaEarthquakeCountryRecord(kfr.country, 1, kfr.dep, kfr.temp, kfr.mag,
//              kfr.fog, kfr.rain, kfr.snow, kfr.hail, kfr.thunder, kfr.tornado, kfr.clear)
           KafkaEarthquakeCountryRecord(kfr.country, 0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0)
       }})
    
      batchStats.print()
    // Start the computation
    ssc.start()
    ssc.awaitTermination()
  }

}
CREATE EXTERNAL TABLE IF NOT EXISTS xw_weathersummary_2017
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.thrift.ThriftDeserializer'
WITH SERDEPROPERTIES (
'serialization.class' = 'edu.uchicago.mpcs53013.weatherSummary.WeatherSummary', 'serialization.format' = 'org.apache.thrift.protocol.TBinaryProtocol')
STORED AS SEQUENCEFILE
LOCATION '/inputs/thriftWeather2017';

create table xw_orcweathersummary (station int, year
smallint, month tinyint, day tinyint, meantemperature
double, meanvisibility double, meanwindspeed double, fog
boolean, rain boolean, snow boolean, hail boolean,
thunder boolean, tornado boolean) stored as orc;

insert overwrite table xw_orcweathersummary select * from xw_weathersummary_2017;

insert into table xw_orcweathersummary select * from orcweathersummary;
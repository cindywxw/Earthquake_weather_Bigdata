create external table xw_earthquakeweather_hb (
  id string, time string, year smallint, month tinyint,
  day tinyint, latitude double, longitude double, 
  depth double, mag double, temp double, 
  country string, fog int, rain int, snow int,
  hail int,thunder int, tornado int, clear int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, eq:time, eq:year, eq:month, eq:day, eq:latitude, eq:longitude, eq:depth, eq:mag, eq:temp, eq:country, eq:fog, eq:rain, eq:snow, eq:hail, eq:thunder, eq:tornado, eq:clear')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquakeweather_hb');


insert overwrite table xw_earthquakeweather_hb
select id, time as time, year, month, day,
  latitude, longitude, depth, mag, temp, country,
  fog, rain, snow, hail, thunder, tornado, clear
from xw_earthquakeweather;


create external table xw_earthquakeweather_speed (
  id string, time string, year smallint, month tinyint,
  day tinyint, latitude double, longitude double, 
  depth double, mag double, temp double, 
  country string, fog int, rain int, snow int,
  hail int,thunder int, tornado int, clear int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, eq:time, eq:year, eq:month, eq:day, eq:latitude, eq:longitude, eq:depth, eq:mag, eq:temp, eq:country, eq:fog, eq:rain, eq:snow, eq:hail, eq:thunder, eq:tornado, eq:clear')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquakeweather_speed');


create external table xw_earthquakeweather_bk (
  id string, time string, year smallint, month tinyint,
  day tinyint, latitude double, longitude double, 
  depth double, mag double, temp double, 
  country string, fog int, rain int, snow int,
  hail int,thunder int, tornado int, clear int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, eq:time, eq:year, eq:month, eq:day, eq:latitude, eq:longitude, eq:depth, eq:mag, eq:temp, eq:country, eq:fog, eq:rain, eq:snow, eq:hail, eq:thunder, eq:tornado, eq:clear')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquakeweather_bk');


insert overwrite table xw_earthquakeweather_bk
select id, time as time, year, month, day,
  latitude, longitude, depth, mag, temp, country,
  fog, rain, snow, hail, thunder, tornado, clear
from xw_earthquakeweather;



create external table xw_earthquakeweather_by_country (
  country string, count int,
  depth double, temp double, mag double,
  fog int, rain int, snow int, hail int,
  thunder int, tornado int, clear int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, cnty:count, cnty:depth, cnty:temp, cnty:mag, cnty:fog, cnty:rain, cnty:snow, cnty:hail, cnty:thunder, cnty:tornado, cnty:clear')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquakeweather_by_country');

insert overwrite table xw_earthquakeweather_by_country
select country, count(1), sum(depth), sum(temp), sum(mag),
  sum(fog), sum(rain), sum(snow), sum(hail),
  sum(thunder), sum(tornado), sum(clear)
from xw_earthquakeweather
group by country;

create external table xw_earthquakeweather_by_country_speed (
  country string, count int,
  depth double, temp double, mag double,
  fog int, rain int, snow int, hail int,
  thunder int, tornado int, clear int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, cnty:count, cnty:depth, cnty:temp, cnty:mag, cnty:fog, cnty:rain, cnty:snow, cnty:hail, cnty:thunder, cnty:tornado, cnty:clear')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquakeweather_by_country_speed');



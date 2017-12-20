create table test(
  id string,
  latitude double,
  longitude double);

insert overwrite table test
  select id as name, latitude, longitude from xw_earthquake_cut limit 5;

create table test_station(
code string, name string, lat double, lon double, country string);

insert overwrite table test_station
  select * from xw_stations limit 3;

create table test_join_tmp(
  id string, Station int, Lat1 double, Lon1 double, Lat2 double, Lon2 double,
  Dist double)
  stored as orc;

insert overwrite table test_join_tmp 
  select distinct e.id as id, s.code as station, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist
  from test e join test_station s;

create table test_join(
  Id string, Station int,
  Latitude double, Longitude double)
  stored as orc;

insert overwrite table test_join 
  select distinct t.id as id, t.station as station, t.lat1 as latitude, t.lat1 as longitude
  from test_join_tmp as t
    join (
      select id, min(dist) as mindist
      from test_join_tmp
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;






create table xw_earthquake_cut7(
  Id string,
  EventTime string,
  Year smallint,
  Month tinyint,
  Day tinyint,
  Latitude double,
  Longitude double,
  Depth double,
  Mag double)
  stored as orc;

create table xw_earthquake_cut8(
  Id string,
  EventTime string,
  Year smallint,
  Month tinyint,
  Day tinyint,
  Latitude double,
  Longitude double,
  Depth double,
  Mag double)
  stored as orc;

create table xw_earthquake_cut9(
  Id string,
  EventTime string,
  Year smallint,
  Month tinyint,
  Day tinyint,
  Latitude double,
  Longitude double,
  Depth double,
  Mag double)
  stored as orc;

create table xw_earthquake_cut10(
  Id string,
  EventTime string,
  Year smallint,
  Month tinyint,
  Day tinyint,
  Latitude double,
  Longitude double,
  Depth double,
  Mag double)
  stored as orc;

from (
 select *, floor(rand()*10) as part from xw_earthquake_cut
) t
insert into xw_earthquake_cut1 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 0
insert into xw_earthquake_cut2 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 1
insert into xw_earthquake_cut3 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 2
insert into xw_earthquake_cut4 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 3
insert into xw_earthquake_cut5 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 4
insert into xw_earthquake_cut6 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 5
insert into xw_earthquake_cut7 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 6
insert into xw_earthquake_cut8 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 7
insert into xw_earthquake_cut9 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 8
insert into xw_earthquake_cut10 select id, eventtime,year,month,day,latitude,longitude,depth,mag where part = 9;




create table xw_earthquakesummary_nw(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_nw
  select distinct t.id as id, t2.station as station, t.eventtime as eventtime,
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude, t.country as country,
  t.depth as depth, t.mag as mag
  from xw_earthquake_cut1 as t
    join xw_eqstation_join_tmp1 as tj
    on t.id = tj.id;


create external table xw_earthquakeweather_by_mag (
  mag double, count int,
  depth double, temp double, 
  fogc int, fogs double, 
  rainc int, rains double, 
  snowc int, snows double, 
  hailc int, hails double, 
  thunderc int, thunders double, 
  tornadoc int, tornados double, 
  clearc int, clears double)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, mag:count, mag:depth, mag:temp, mag:fogc, mag:fogs, mag:rainc, mag:rains, mag:snowc, mag:snows, eq:hailc, eq:hails, mag:thunderc, mag:thunders, mag:tornadoc, mag:tornados, mag:clearc, mag:clears')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquakeweather_by_mag');

insert overwrite table xw_earthquakeweather_by_mag
select floor(mag), count(*), sum(depth), sum(temp),
  count(if(fog,1,null), sum(fog), 
  count(if(rain,1,null), sum(rain), 
  count(if(snow,1,null), sum(snow), 
  count(if(hail,1,null), sum(hail),
  count(if(thunder,1,null), sum(thunder), 
  count(if(tornado,1,null), sum(tornado), 
  count(if(clear,1,null), sum(clear)
from xw_earthquakeweather;


create external table xw_earthquakeweather_by_mag_speed (
  mag double, count int,
  depth double, temp double, 
  fogc int, fogs double, 
  rainc int, rains double, 
  snowc int, snows double, 
  hailc int, hails double, 
  thunderc int, thunders double, 
  tornadoc int, tornados double, 
  clearc int, clears double)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, mag:count, mag:depth, mag:temp, mag:fogc, mag:fogs, mag:rainc, mag:rains, mag:snowc, mag:snows, eq:hailc, eq:hails, mag:thunderc, mag:thunders, mag:tornadoc, mag:tornados, mag:clearc, mag:clears')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquakeweather_by_mag_speed');

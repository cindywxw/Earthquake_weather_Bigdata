create external table xw_earthquake_csv(
  EventTime string,
  Latitude decimal,
  Longitude decimal,
  Depth decimal,
  Mag decimal,
  MagType string,
  Nst smallint,
  Gap decimal,
  Dmin decimal,
  Rms decimal,
  Net string,
  Id string,
  Updated string,
  Place string,
  Type string,
  HorizontalError decimal,
  DepthError decimal,
  MagError decimal,
  MagNst smallint,
  Status string,
  LocationSource string,
  MagSource string)
  row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'

WITH SERDEPROPERTIES (
   "separatorChar" = "\,",
   "quoteChar"     = "\""
)
STORED AS TEXTFILE
  location '/inputs/cindywen/earthquake';


create external table xw_stations(code string, name string, lat double, lon double, country string)
row format delimited fields terminated by ','
stored as textfile
location '/inputs/cindywen/stations';

create external table xw_stations_nw(code string, name string, lat double, lon double, country string)
stored as orc;

insert overwrite table xw_stations_nw
  select * from xw_stations
  where lat > 0 and lon <= -25;

create external table xw_stations_nm(code string, name string, lat double, lon double, country string)
stored as orc;

insert overwrite table xw_stations_nm
  select * from xw_stations
  where lat > 0 and lon > -25 and lon < 60;

create external table xw_stations_ne(code string, name string, lat double, lon double, country string)
stored as orc;

insert overwrite table xw_stations_ne
  select * from xw_stations
  where lat > 0 and lon >= 60;

create external table xw_stations_sw(code string, name string, lat double, lon double, country string)
stored as orc;

insert overwrite table xw_stations_sw
  select * from xw_stations
  where lat <= 0 and lon <= -25;

create external table xw_stations_sm(code string, name string, lat double, lon double, country string)
stored as orc;

insert overwrite table xw_stations_sm
  select * from xw_stations
  where lat <= 0 and lon > -25 and lon < 60;

create external table xw_stations_se(code string, name string, lat double, lon double, country string)
stored as orc;

insert overwrite table xw_stations_se
  select * from xw_stations
  where lat <= 0 and lon >= 60;

create table xw_earthquake(
  EventTime string,
  Latitude decimal,
  Longitude decimal,
  Depth decimal,
  Mag decimal,
  MagType string,
  Nst smallint,
  Gap decimal,
  Dmin decimal,
  Rms decimal,
  Net string,
  Id string,
  Updated string,
  Place string,
  Type string,
  HorizontalError decimal,
  DepthError decimal,
  MagError decimal,
  MagNst smallint,
  Status string,
  LocationSource string,
  MagSource string)
  stored as orc;

insert overwrite table xw_earthquake select * from xw_earthquake_csv
where eventtime is not null and latitude is not null
and longitude is not null and depth is not null
and eventtime != "time" and mag is not null;

create table xw_earthquake_cut(
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

insert overwrite table xw_earthquake_cut 
select distinct id, eventtime, substr(eventtime,0,4), substr(eventtime,6,2), substr(eventtime,9,2), latitude, longitude, depth, mag from xw_earthquake_csv
where eventtime is not null and latitude is not null
and longitude is not null and depth is not null
and eventtime != "time" and mag is not null and type = "earthquake";

create table xw_earthquake_cut_nw(
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

create table xw_earthquake_cut_nm(
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

create table xw_earthquake_cut_ne(
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

create table xw_earthquake_cut_sw(
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

create table xw_earthquake_cut_sm(
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

create table xw_earthquake_cut_se(
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

from xw_earthquake_cut
insert into xw_earthquake_cut_nw select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude > 0 and longitude <= -25
insert into xw_earthquake_cut_nm select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude > 0 and longitude > -25 and longitude < 60
insert into xw_earthquake_cut_ne select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude > 0 and longitude >= 60
insert into xw_earthquake_cut_sw select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude <= 0 and longitude <= -25
insert into xw_earthquake_cut_sm select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude <= 0 and longitude > -25 and longitude < 60
insert into xw_earthquake_cut_se select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude <= 0 and longitude >= 60;


create table xw_earthquake_cut_nw_1(
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


create table xw_earthquake_cut_nw_2(
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


create table xw_earthquake_cut_nw_3(
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


create table xw_earthquake_cut_nw_4(
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

from xw_earthquake_cut_nw
insert overwrite table xw_earthquake_cut_nw_1 select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude > 45 and longitude <= -120
insert overwrite table xw_earthquake_cut_nw_2 select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude > 45 and longitude > -120
insert overwrite table xw_earthquake_cut_nw_3 select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude <=45 and longitude <= -120 
insert overwrite table xw_earthquake_cut_nw_4 select id, eventtime,year,month,day,latitude,longitude,depth,mag where latitude <=45 and longitude > -120;


create external table xw_stations_nw_1(
code string, name string, lat double, lon double, country string)
stored as orc;

create external table xw_stations_nw_2(
code string, name string, lat double, lon double, country string)
stored as orc;

create external table xw_stations_nw_3(
code string, name string, lat double, lon double, country string)
stored as orc;

create external table xw_stations_nw_4(
code string, name string, lat double, lon double, country string)
stored as orc;

insert overwrite table xw_stations_nw_1
  select * from xw_stations_nw
  where lat > 45 and lon <= -120;

insert overwrite table xw_stations_nw_2
  select * from xw_stations_nw
  where lat > 45 and lon > -120;

insert overwrite table xw_stations_nw_3
  select * from xw_stations_nw
  where lat <= 45 and lon <= -120;

insert overwrite table xw_stations_nw_4
  select * from xw_stations_nw
  where lat <= 45 and lon > -120;

create table xw_earthquake_station_tmp_nw_1(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_nw_1 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_nw_1 e join xw_stations_nw_1 s;

create table xw_earthquake_station_tmp_nw_2(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_nw_2 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_nw_2 e join xw_stations_nw_2 s;

create table xw_earthquake_station_tmp_nw_3(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_nw_3 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_nw_3 e join xw_stations_nw_3 s;

create table xw_earthquake_station_tmp_nw_4(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_nw_4 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_nw_4 e join xw_stations_nw_4 s;

create table xw_earthquakesummary_nw_1(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_nw_1 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime,
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_nw_1 as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_nw_1
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquakesummary_nw_2(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_nw_2 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime, 
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_nw_2 as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_nw_2
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquakesummary_nw_3(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_nw_3 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime, 
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_nw_3 as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_nw_3
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquakesummary_nw_4(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_nw_4 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime,
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_nw_4 as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_nw_4
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquake_station_tmp_nm(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_nm 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_nm e join xw_stations_nm s;

create table xw_earthquake_station_tmp_ne(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_ne 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_ne e join xw_stations_ne s;

create table xw_earthquake_station_tmp_sw(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_sw 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_sw e join xw_stations_sw s;


create table xw_earthquake_station_tmp_sm(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_sm 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_sm e join xw_stations_sm s;

create table xw_earthquake_station_tmp_se(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  lat1 double, lon1 double, lat2 double, lon2 double,
  dist double, country string, depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquake_station_tmp_se 
  select e.id as id, s.code as station, e.eventtime as eventtime,
  e.year as year, e.month as month, e.day as day, 
  e.latitude as lat1, e.longitude as lon1, s.lat as lat2, s.lon as lon2,
  ((e.latitude - s.lat)*(e.latitude - s.lat)+(e.longitude - s.lon)*(e.longitude - s.lon)) as dist,
  s.country as country, e.depth as depth, e.mag as mag
  from xw_earthquake_cut_se e join xw_stations_se s;



create table xw_earthquakesummary_nm(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_nm 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime, 
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_nm as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_nm
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquakesummary_ne(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_ne 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime,
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_ne as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_ne
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquakesummary_sw(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_sw 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime, 
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_sw as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_sw
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquakesummary_sm(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_sm 
  select distinct t.id as id, t.station as station, t.eventtime as eventtime, 
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_sm as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_sm
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;

create table xw_earthquakesummary_se(
  id string, station int, eventtime string,
  year smallint, month tinyint, day tinyint, 
  latitude double, longitude double, country string,
  depth double, mag double)
  stored as orc;

insert overwrite table xw_earthquakesummary_se 
  select distinct t.id as id,  t.station as station, t.eventtime as eventtime,
  t.year as year, t.month as month, t.day as day,
  t.lat1 as latitude, t.lon1 as longitude,
  t.country as country, t.depth as depth, t.mag as mag
  from xw_earthquake_station_tmp_se as t
    join (
      select id, min(dist) as mindist
      from xw_earthquake_station_tmp_se
      group by id) as tt
    on t.id = tt.id 
    and t.dist = tt.mindist;


create table xw_earthquakeweather(
  id string, time string, year smallint, month tinyint,
  day tinyint, latitude double, longitude double, depth double, mag double,
  temp double, country string, fog int, rain int, snow int,
  hail int,thunder int, tornado int, clear int)
  stored as orc;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_nm e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_ne e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_sw e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_sm e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_se e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_nw_1 e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day; 

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_nw_2 e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado,
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_nw_3 e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;

insert into xw_earthquakeweather
  select e.id as id, e.eventtime as time, e.year as year,
  e.month as month, e.day as day, e.latitude as latitude, e.longitude as longitude,
  e.depth as depth, e.mag as mag, w.meantemperature as temp,
  e.country as country, if(w.fog,1,0) as fog, if(w.rain,1,0) as rain, 
  if(w.snow,1,0) as snow, if(w.hail,1,0) as hail, if(w.thunder,1,0) as thunder,
  if(w.tornado,1,0) as tornado, 
  if(w.fog or w.rain or w.snow or w.hail or w.thunder or w.tornado,0,1) as clear
  from xw_earthquakesummary_nw_4 e join xw_orcweathersummary w
    on e.station = w.station and e.year = w.year 
    and e.month = w.month and e.day = w.day;


create table xw_earthquakeweather_backup(
  id string, time string, year smallint, month tinyint,
  day tinyint, latitude double, longitude double, depth double, mag double,
  temp double, country string, fog int, rain int, snow int,
  hail int,thunder int, tornado int, clear int)
  stored as orc;

insert into xw_earthquakeweather_backup
  select * from xw_earthquakeweather;



drop table xw_earthquake_cut_ne;
drop table xw_earthquake_cut_nm;
drop table xw_earthquake_cut_nw;
drop table xw_earthquake_cut_nw_1;
drop table xw_earthquake_cut_nw_2;
drop table xw_earthquake_cut_nw_3;
drop table xw_earthquake_cut_nw_4;
drop table xw_earthquake_cut_se;
drop table xw_earthquake_cut_sm;
drop table xw_earthquake_cut_sw;
drop table xw_earthquake_station_tmp_ne;
drop table xw_earthquake_station_tmp_nm;
drop table xw_earthquake_station_tmp_nw;
drop table xw_earthquake_station_tmp_nw_1;
drop table xw_earthquake_station_tmp_nw_2;
drop table xw_earthquake_station_tmp_nw_3;
drop table xw_earthquake_station_tmp_nw_4;
drop table xw_earthquake_station_tmp_se;
drop table xw_earthquake_station_tmp_sm;
drop table xw_earthquake_station_tmp_sw;
drop table stations_hb;
drop table stations_ne;
drop table stations_nm;
drop table stations_nw;
drop table stations_nw_1;
drop table stations_nw_2;
drop table stations_nw_3;
drop table stations_nw_4;
drop table stations_se;
drop table stations_sm;
drop table stations_sw;

create external table xw_earthquake_csv(
  EventTime string,
  Latitude double,
  Longitude double,
  Depth double,
  Mag double,
  MagType string,
  Nst smallint,
  Gap double,
  Dmin double,
  Rms double,
  Net string,
  Id string,
  Updated string,
  Place string,
  Type string,
  HorizontalError double,
  DepthError double,
  MagError double,
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
  location '/inputs/earthquakedata';

select eventtime, latitude, longitude from xw_earthquake_csv limit 5;

create external table xw_stations(code string, name string, lat double, lon double, country string)
row format delimited fields terminated by ','
stored as textfile
location '/inputs/station'; 


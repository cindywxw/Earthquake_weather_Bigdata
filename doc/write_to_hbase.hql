create external table xw_earthquake_hb (
  id string,
  event_time string,
  latitude double,
  longitude double,
  depth double,
  mag double,
  mag_type double,
  nst smallint,
  gap double,
  dmin double,
  rms double,
  net string,
  updated string,
  place string,
  type string,
  horizontal_error double,
  depth_error double,
  mag_error double,
  mag_nst smallint,
  status string,
  location_source string,
  mag_source string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,eq:event_time,eq:latitude,eq:longitude,eq:depth,eq:mag,eq:mag_type,eq:nst,eq:gap,eq:dmin,eq:rms,eq:net,eq:updated,eq:place,eq:type,eq:horizontal_error,eq:depth_error,eq:mag_error,eq:mag_nst,eq:status,eq:location_source,eq:mag_source')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquake_hb');


insert overwrite table xw_earthquake_hb
select Id, EventTime, Latitude, Longitude,
  Depth, Mag, MagType, Nst, Gap, Dmin, Rms,
  Net, Updated, Place, Type,
  HorizontalError, DepthError, MagError,
  MagNst, Status, LocationSource, MagSource
from xw_earthquake;


create external table xw_stations_hb (
  code string,
  name string,
  lat double,
  lon double,
  country string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,stn:name,stn:lat,stn:lon,stn:country')
TBLPROPERTIES ('hbase.table.name' = 'xw_stations_hb');


insert overwrite table xw_stations_hb
select code, name, lat, lon, country
from xw_stations;

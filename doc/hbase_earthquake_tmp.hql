create external table xw_earthquake_tmp (
  id string,
  event_time string,
  year smallint,
  latitude double,
  longitude double,
  depth double,
  mag double,
  sig tinyint,
  temp double,
  country string,
  fog int,
  rain int,
  snow int,
  hail int,
  thunder int,
  tornado int,
  clear int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,eq:event_time,eq:year,eq:latitude,eq:longitude,eq:depth,eq:mag,eq:sig,eq:temp,eq:country,eq:fog,eq:rain,eq:snow,eq:hail,eq:thunder,eq:tornado,eq:clear')
TBLPROPERTIES ('hbase.table.name' = 'xw_earthquake_tmp');


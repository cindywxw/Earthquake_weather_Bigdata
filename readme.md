
Earthquake data from USGS(https://earthquake.usgs.gov/fdsnws/event/1) and weather data from NOAA (ftp://ftp.ncdc.noaa.gov/pub/data/gsod) are used to form the batch layer. Earthquake recodes in the United States takes the largest amount of the dataset. For the "country" property, most places in the U.S are marked with the states directly. For streaming data for speed layer, I used earthquake data from USGS (https://earthquake.usgs.gov/earthquakes/feed/v1.0/geojson.php) and weather data from OpenWeatherMap (https://openweathermap.org/api) for latest update. 

The earthquake record doesn't come with weather information. It contains coordinates, and that information can be used to find the nearest WMO station and corresponding weather data can be reached. I split the earthquake data and WMO stations based on latitude and longitude, and compare the distances in the same area. 

After I got the nearest station of the earthquake spot and caught the weather data on that day, I join the data and got a earthquakeweather table that contains the most of the meaningful information. Then I used derived table to do queries for the batch layer and speed layer. I used xw_earthquakeweather_by_country for batch view and xw_earthquakeweather_by_country_speed for speed layer. And I used apiearthquake to fetch latest earthquake and weather data. Also a xw_earthquakeweather_speed is used to check if there is repeated record based on the unique id for every earthquake to avoid duplicate records.

Url: http://35.194.29.210/cindywen/earthquake-country.html

Commands used for this project:
```shell
./getEarthquake.sh
./getWeather.sh
``` 
getStations (java program)
```shell
java -cp uber-apiearthquake-0.0.1-SNAPSHOT.jar edu.uchicago.cindywen.apiearthquake.LatestEarthquakes
add jar hdfs:///pathto/uber-weatheringest-0.0.1-SNAPSHOT.jar;
```  
!run /pathto/hive_earthquake_cluster.hql;  
!run /pathto/orcweather_cluster.hql;  
!run /pathto/write_to_hbase2.hql;  

```shell
./kafka-topics.sh --create --zookeeper 10.0.0.3:2181 --replication-factor 1 --partitions 1 --topic earthquake
./kafka-topics.sh -list -zookeeper 10.0.0.3:2181
./kafka-console-coumer.sh --bootstrap-server 10.0.0.2:6667 --topic earthquake --from-beginning --zookeeper 10.0.0.3:2181
spark-submit --master local[2] --class StreamData uber-earthquakestream-0.0.1-SNAPSHOT.jar 10.0.0.2:6667
```

hbase:
create 'xw_earthquakeweather_hb', 'eq'  
create 'xw_earthquakeweather_speed', 'eq'  
create 'xw_earthquakeweather_bk', 'eq'  
create 'xw_earthquakeweather_by_country', 'cnty'  
create 'xw_earthquakeweather_by_country_speed', 'cnty'  


 
With a closer look at the results, it turns out that although earthquakes happened mostly in clear conditions, as the magnitude of the earthquake increases, the trends of rain and thunder also increase. Therefore, I believe there is correlation between earthquake and weather. Another finding is that the depth where the earthquake begins to rupture goes deeper as the magnitude of the earthquake increases.
 

```shell 
select floor(mag), count(1),
CAST(AVG(CAST(depth as DECIMAL(10,3))) AS DECIMAL(10,3)),
CAST(AVG(CAST(temp as DECIMAL(10,3))) AS DECIMAL(10,3)),
CAST(AVG(CAST(fog as DECIMAL(10,3))) AS DECIMAL(10,3)),
CAST(AVG(CAST(rain as DECIMAL(10,3))) AS DECIMAL(10,3)),
CAST(AVG(CAST(snow as DECIMAL(10,3))) AS DECIMAL(10,3)),
CAST(AVG(CAST(hail as DECIMAL(10,3))) AS DECIMAL(10,3)),
CAST(AVG(CAST(thunder as DECIMAL(10,3))) AS DECIMAL(10,3)), 
CAST(AVG(CAST(tornado as DECIMAL(10,3))) AS DECIMAL(10,3)), 
CAST(AVG(CAST(clear as DECIMAL(10,3))) AS DECIMAL(10,3))
from xw_earthquakeweather
where mag is not null
group by floor(mag);
```

**mag**|**count**|**depth**|**temp**|**fog**|**rain**|**snow**|**hail**|**thunder**|**tornado**|**clear**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
-2|77|5.994|63.81|0|0.156|0.026|0|0|0|0.831
-1|14547|6.65|58.947|0.039|0.121|0.043|0|0.007|0|0.839
0|230821|4.923|55.754|0.06|0.194|0.028|0|0.004|0|0.75
1|184967|14.907|54.585|0.06|0.186|0.044|0|0.007|0|0.752
2|70927|23.678|57.337|0.047|0.221|0.043|0|0.027|0|0.727
3|33462|39.571|62.878|0.036|0.233|0.031|0.001|0.045|0|0.719
4|65318|58.829|69.5|0.035|0.355|0.025|0.001|0.073|0|0.589
5|9358|46.143|69.32|0.029|0.376|0.022|0.001|0.067|0|0.576
6|748|64.481|68.587|0.033|0.36|0.04|0.001|0.08|0|0.582
7|78|100.46|69.918|0.026|0.346|0.013|0|0.064|0|0.603
8|7|109.157|66.971|0|0|0|0|0|0|1


For geographical factors, the 10 countries(areas) that suffer the earthquakes with the greatest magnitude, includes United States, French Guiana, Comoros(IC), Zaire(ZR), St Helena(HE), Falkland Island, Belize, and Cape Verde. Most of them are in Atlantic Ocean and near Africa.

country|count|depth|mag|temp|fog|rain|snow|hail|thunder|tornado|clear
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
US|4|10|5.55|30.05|0.5|0.5|0.75|0|0|0|0.25
FG|1|10|5|79.5|0|1|0|0|0|0|0
IC|4|10|4.95|79.675|0|0|0|0|0|0|1
ZR|1|10|4.9|80.6|0|0|0|0|0|0|1
HE|86|10.153|4.83|64.781|0.116|0.419|0|0|0|0|0.547
FK|23|14.281|4.826|36.248|0|0.087|0|0|0|0|0.913
UY|2|13.8|4.8|33.4|0|1|0|0|0|0|0
BZ|30|19.575|4.793|83.433|0.067|0.4|0|0|0.1|0|0.467
CV|154|10.123|4.761|75.665|0|0.039|0|0|0|0|0.961
BC|12|13.371|4.75|72.325|0|0.083|0|0|0.083|0|0.917

As for the places that suffer the earthquakes most frequently, other than the places in the U.S. (There are tons of earthquake records regarding the U.S.), Japan, Puerto Rico Chile are the places that suffer a lot of earthquakes every now and then.


for yr in `seq 2006 2017`;
do
  wget -O ${yr}_01.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-01-01&endtime=${yr}-01-31
  wget -O ${yr}_02.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-02-01&endtime=${yr}-02-31
  wget -O ${yr}_03.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-03-01&endtime=${yr}-03-31
  wget -O ${yr}_04.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-04-01&endtime=${yr}-04-31
  wget -O ${yr}_05.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-05-01&endtime=${yr}-05-31
  wget -O ${yr}_06.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-06-01&endtime=${yr}-06-31
  wget -O ${yr}_07.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-07-01&endtime=${yr}-07-31
  wget -O ${yr}_08.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-08-01&endtime=${yr}-08-31
  wget -O ${yr}_09.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-09-01&endtime=${yr}-06-31
  wget -O ${yr}_10.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-10-01&endtime=${yr}-10-31
  wget -O ${yr}_11.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-11-01&endtime=${yr}-11-31
  wget -O ${yr}_12.csv https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=${yr}-12-01&endtime=${yr}-12-31
done
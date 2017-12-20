#!/bin/bash
mkdir weatherData
cd weatherData
year=2017
while [ $year -le 2017 ]
do
    wget ftp://ftp.ncdc.noaa.gov/pub/data/gsod/$year/gsod_$year.tar
    (( year++ ))
done

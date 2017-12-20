for name in *.csv
  do hdfs dfs -put $name /inputs/cindywen/earthquake/${name%.csv}.csv;
done

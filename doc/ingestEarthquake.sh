for name in *.csv
  do hdfs dfs -put $name /inputs/earthquake/${name%.csv}.csv;
done

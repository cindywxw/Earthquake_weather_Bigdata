package edu.uchicago.cindywen.testUDFunc;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.hive.ql.exec.UDAFEvaluator;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.SequenceFile;
import org.apache.hadoop.io.SequenceFile.CompressionType;
import org.apache.hadoop.io.SequenceFile.Writer;


@Description(
		name = "testudf",
		value = "_FUNC_(str, str) - ",
		extended = "Example: \n" +
				"SELECT testudf(lat,lon) FROM xw_earthquake;"
		)
public class TestUDF extends UDF {
	public Double evaluate(Double a) {
		return a+1;
	}
//	public Double evaluate(final Double s) {
//		if (s == null) {
//			return null;
//		}
//		String cleaned = Util.filterOutProfanity(s.toString());		
//		return new Text(cleaned);
//	}
	
//	private Hashtable<String, Double[]> stationTable = new Hashtable<String, Double[]>();
//	
//	public void readStation() {
//		try {
//			Configuration conf = new Configuration();
//			conf.addResource(new Path("/home/mpcs53013/hadoop/etc/hadoop/core-site.xml"));
//			conf.addResource(new Path("/home/mpcs53013/hadoop/etc/hadoop/hdfs-site.xml"));
////			final Configuration finalConf = new Configuration(conf);
//			final FileSystem fs = FileSystem.get(conf);
//			
//			FSDataInputStream in = fs.open(new Path("/inputs/station/stations.txt"));
//	        BufferedReader br = new BufferedReader(new InputStreamReader(in));    
//	        
//	        String str;
//	        while ((str = br.readLine()) != null) {
//	        	String[] contents = str.split(",");
//	        	String code = contents[0];
////	        	String name = contents[1];
//	        	Double lat = Double.parseDouble(contents[2]);
//	        	Double lon = Double.parseDouble(contents[3]);	
//	        	stationTable.put(code, new Double[] {lat,lon});	        	
//	        }	        
//	        br.close();
//	        return;
//
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}		
//	}

	/**
	 * The actual class for doing the aggregation. Hive will automatically look for
	 * all internal classes of the UDAF that implements UDAFEvaluator.
	 */
//	public static class UDAFFilteredSDEvaluator implements UDAFEvaluator {
//	public static class UDAFFilteredSDEvaluator {
//		UDAFFilteredSDState state;
//
//		public UDAFFilteredSDEvaluator() {
//			super();
//			state = new UDAFFilteredSDState();
//			init();
//		}
//
//		/**
//		 * Reset the state of the aggregation.
//		 */
//		public void init() {
//			state.mean = 0;
//			state.M2 = 0;
//			state.count = 0;
//		}
//
//		/**
//		 * Iterate through one row of original data.
//		 * 
//		 * The number and type of arguments need to the same as we call this UDAF from
//		 * Hive command line.
//		 * 
//		 * This function should always return true.
//		 */
//		public boolean iterate(Double x, Boolean include) {
//			if (x != null && include != null && include.booleanValue()) {
//				state.count++;
//				double delta = x - state.mean;
//				state.mean += delta / state.count;
//				state.M2 += (x - state.mean) * delta;
//			}
//			return true;
//		}
//
//		/**
//		 * Terminate a partial aggregation and return the state. If the state is a
//		 * primitive, just return primitive Java classes like Integer or String.
//		 */
//		public UDAFFilteredSDState terminatePartial() {
//			return state;
//		}
//
//		/**
//		 * Merge with a partial aggregation.
//		 * 
//		 * This function should always have a single argument which has the same type as
//		 * the return value of terminatePartial().
//		 */
//		public boolean merge(UDAFFilteredSDState o) {
//			if (o != null) {
//				long totalCount = state.count + o.count;
//				double delta = state.mean - o.mean;
//				state.mean += delta * o.count / totalCount;
//				state.M2 += o.M2 + delta * delta * state.count * o.count / totalCount;
//				state.count = totalCount;
//			}
//			return true;
//		}
//
//		/**
//		 * Terminates the aggregation and return the final result.
//		 */
//		public Double terminate() {
//			return state.count < 2 ? 0.0 : Math.sqrt(state.M2 / (state.count - 1));
//		}
//	}
//
//	private UDAFFilteredSD() {
//		// prevent instantiation
//	}

}

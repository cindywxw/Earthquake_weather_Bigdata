#!/usr/bin/perl -w
# Creates an html table of flight delays by weather for the given route

# Needed includes
use strict;
use warnings;
use 5.10.0;
use HBase::JSONRest;
use CGI qw/:standard/;

# Read the origin and destination airports as CGI parameters
# my $mag = param('mag');
my $cnty = param('cnty');
 
# Define a connection template to access the HBase REST server
# If you are on out cluster, hadoop-m will resolve to our Hadoop master
# node, which is running the HBase REST server
my $hbase = HBase::JSONRest->new(host => "10.0.0.5:8082");
#my $hbase = HBase::JSONRest->new(host => "localhost:8080");
# This function takes a row and gives you the value of the given column
# E.g., cellValue($row, 'delay:rain_delay') gives the value of the
# rain_delay column in the delay family.
# It uses somewhat tricky perl, so you can treat it as a black box
sub cellValue {
    my $row = $_[0];
    my $field_name = $_[1];
    my $row_cells = ${$row}{'columns'};
    foreach my $cell (@$row_cells) {
	if ($$cell{'name'} eq $field_name) {
	    return $$cell{'value'};
	}
    }
    return 'missing';
}

# Query hbase for the route. For example, if the departure airport is ORD
# and the arrival airport is DEN, the "where" clause of the query will
# require the key to equal ORDDEN
my $records = $hbase->get({
  table => 'xw_earthquakeweather_by_country',
  where => {
    key_equals => $cnty
  },
});

my $speed_records = $hbase->get({
  table => 'xw_earthquakeweather_by_country_speed',
  where => {
    key_equals => $cnty
  },
});

# There will only be one record for this route, which will be the
# "zeroth" row returned
my $row = @$records[0];
my $speed_row = @$speed_records[0];
    
# Get the value of all the columns we need and store them in named variables
# Perl's ability to assign a list of values all at once is very convenient here
my($eqcount, $depth_sum, $temp_sum, $mag_sum, $fog_count, $rain_count,
   $snow_count, $hail_count, $thunder_count, $tornado_count, $clear_count)
 =  (cellValue($row, 'cnty:count'), cellValue($row, 'cnty:depth'),
     cellValue($row, 'cnty:temp'), cellValue($row, 'cnty:mag'),
     cellValue($row, 'cnty:fog'), cellValue($row, 'cnty:rain'),
     cellValue($row, 'cnty:snow'), cellValue($row, 'cnty:hail'),
     cellValue($row, 'cnty:thunder'), cellValue($row, 'cnty:tornado'),
     cellValue($row, 'cnty:clear'));

my($eqcount_s, $depth_sum_s, $temp_sum_s, $mag_sum_s, $fog_count_s, $rain_count_s,
   $snow_count_s, $hail_count_s, $thunder_count_s, $tornado_count_s, $clear_count_s)
 =  (cellValue($speed_row, 'cnty:count'), cellValue($speed_row, 'cnty:depth'),
     cellValue($speed_row, 'cnty:temp'), cellValue($speed_row, 'cnty:mag'),
     cellValue($speed_row, 'cnty:fog'), cellValue($speed_row, 'cnty:rain'),
     cellValue($speed_row, 'cnty:snow'), cellValue($speed_row, 'cnty:hail'),
     cellValue($speed_row, 'cnty:thunder'), cellValue($speed_row, 'cnty:tornado'),
     cellValue($speed_row, 'cnty:clear'));


sub average_freq {
    my($sum, $count) = @_;
    return $count > 0 ? sprintf("%.2f", $sum/$count) : "-";
}

# Print an HTML page with the table. Perl CGI has commands for all the
# common HTML tags
print header, start_html(-title=>'hello CGI',-head=>Link({-rel=>'stylesheet',-href=>'/cindywen/table.css',-type=>'text/css'}));
print div({-style=>'margin-left:275px;margin-right:auto;display:inline-block;box-shadow: 10px 10px 5px #888888;border:1px solid #000000;-moz-border-radius-bottomleft:9px;-webkit-border-bottom-left-radius:9px;border-bottom-left-radius:9px;-moz-border-radius-bottomright:9px;-webkit-border-bottom-right-radius:9px;border-bottom-right-radius:9px;-moz-border-radius-topright:9px;-webkit-border-top-right-radius:9px;border-top-right-radius:9px;-moz-border-radius-topleft:9px;-webkit-border-top-left-radius:9px;border-top-left-radius:9px;background:white'}, '&nbsp;Earthquake weather data on' . $cnty . '&nbsp;');
print     p({-style=>"bottom-margin:10px"});
print table({-class=>'CSS_Table_Example', -style=>'width:80%;margin:auto;'},
	    Tr([td(['Earthquakes','Depth', 'Temperature', 'Magnitude', 'Fog', 'Rain', 'Snow', 'Hail', 'Thunder', 'Tornado', 'Clear']),
                td([($eqcount + $eqcount_s),
		    average_freq($depth_sum + $depth_sum_s, $eqcount + $eqcount_s),
                    average_freq($temp_sum + $temp_sum_s, $eqcount + $eqcount_s),
                    average_freq($mag_sum + $mag_sum_s, $eqcount + $eqcount_s),
                    average_freq($fog_count + $fog_count_s, $eqcount + $eqcount_s),
                    average_freq($rain_count + $rain_count_s, $eqcount + $eqcount_s),
		    average_freq($snow_count + $snow_count_s, $eqcount + $eqcount_s),
		    average_freq($hail_count + $hail_count_s, $eqcount + $eqcount_s),
                    average_freq($thunder_count + $thunder_count_s, $eqcount + $eqcount_s),
                    average_freq($tornado_count + $tornado_count_s, $eqcount + $eqcount_s),
                    average_freq($clear_count + $clear_count_s, $eqcount + $eqcount_s)])])),
    p({-style=>"bottom-margin:10px"})
    ;

print end_html;

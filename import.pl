#!/usr/bin/perl

# This file is part of weather-graph.

# weather-graph is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# weather-graph is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with weather-graph.  If not, see <http://www.gnu.org/licenses/>.

# Imports existing archived xml files from $xmlpath into
# the database. Useful for testing or if you have older
# data to import.

use XML::Simple;
use Date::Parse;
use DBI;

use strict;

my $dbpath = "/PATH/TO/SQLITE3/DB";
my $xmlpath = "xml/STATION";

my $dbh = DBI->connect("dbi:SQLite:dbname=$dbpath", "", "");
my @files = <$xmlpath/*>;

foreach my $file (@files) {
  local $/ = undef;
  open FILE, "<$file";
  my $data = <FILE>;
  close FILE;

  my $res = new XML::Simple;
  my $xml = $res->XMLin($data);
  
  my $station = $xml->{'station_id'};
  my $timestamp = $xml->{'observation_time_rfc822'};
  $timestamp =~ substr($timestamp, 0, length($timestamp)-6);
  $timestamp = str2time($timestamp);
  my $conditions = $xml->{'weather'};
  my $tempf = $xml->{'temp_f'};
  my $tempc = $xml->{'temp_c'};
  my $winddir = $xml->{'wind_dir'};
  my $winddeg = $xml->{'wind_degrees'};
  my $windmph = $xml->{'wind_mph'};
  my $windknt = $xml->{'wind_kt'};
  my $pressuremb = $xml->{'pressure_mb'};
  my $pressurein = $xml->{'pressure_in'};
  my $dewpointf = $xml->{'dewpoint_f'};
  my $dewpointc = $xml->{'dewpoint_c'};
  my $windchillf = ($xml->{'windchill_f'} ne '') ? $xml->{'windchill_f'} : 'NULL';
  my $windchillc = ($xml->{'windchill_c'} ne '') ? $xml->{'windchill_c'} : 'NULL';
  my $visibility = $xml->{'visibility_mi'};

  my $insert = "INSERT INTO datum VALUES(NULL,'$station',$timestamp,'$conditions',$tempf,$tempc,'$winddir',$winddeg,$windmph,$windknt,$pressuremb,$pressurein,$dewpointf,$dewpointc,$windchillf,$windchillc,$visibility);";
  print "$insert\n";
  $dbh->do($insert);
}

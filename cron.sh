#!/bin/sh

# cron.sh - Copyright 2008, 2009, 2010, and 2011
# Shaun Landis <slandis@gmail.com>
#
# This file is part of weather-graph.
#
# weather-graph is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# weather-graph is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with weather-graph.  If not, see <http://www.gnu.org/licenses/>.

# This script saves the xml hourly from STATION
# uncomment the rm portion if you don't wish to archive

OUTPUT=`date +%s`.xml

wget --output-document=/PATH/TO/XML/ARCHIVE/$OUTPUT -q http://www.weather.gov/xml/current_obs/STATION.xml

/PATH/TO/weather.pl /PATH/TO/XML/ARCHIVE/$OUTPUT

rm /PATH/TO/XML/ARCHIVE/$OUTPUT

exit;

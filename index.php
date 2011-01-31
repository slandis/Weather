<?
/*
* This file is part of weather-graph.
*
* weather-graph is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* weather-graph is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with weather-graph.  If not, see <http://www.gnu.org/licenses/>.
*/
  $db = new PDO('sqlite:weather.db');

  $idata = array();
  $tdata = array();
  $ddata = array();
  $wdata = array();
  $pdata = array();

  $result = $db->query("SELECT MAX(id) as mid from datum");
  $row = $result->fetch(PDO::FETCH_ASSOC);
  $offset = $row['mid'] - 48;
    
  $result = null;
  $row = null;
  
  $result = $db->query("SELECT id,tempf,dewpointf,pressurein,windchillf FROM datum ORDER BY timestamp ASC LIMIT $offset,48");

  foreach ($result as $row) {
    array_push($idata, $row['id']);
    array_push($tdata, $row['tempf']);
    array_push($ddata, $row['dewpointf']);
    array_push($pdata, $row['pressurein']);
    array_push($wdata, $row['windchillf']);
  }

  $db = NULL;
?>
<html>
<head>
<script src="js/RGraph.common.core.js" ></script> 
<script src="js/RGraph.line.js" ></script>
</head>
<body>
<canvas id="MyGraph" width="720" height="300">[Your browser does not support canvases!]</canvas>
<script type="text/javascript">
window.onload = function() {
  graph = new RGraph.Line('MyGraph', [[<? echo implode(',', $tdata); ?>], [<? echo implode(',', $ddata); ?>],[<? echo implode(',', $wdata); ?>]]);
  graph.Set('chart.title', 'KSLE - Weather Data');
  graph.Set('chart.colors', ['red', 'green', 'blue']);
  graph.Set('chart.linewidth', 2);
  graph.Set('chart.gutter', 45);
  graph.Set('chart.background.grid.autofit', true);
  graph.Set('chart.background.grid.autofit.numhlines', 20);
  graph.Set('chart.background.grid.autofit.numvlines', 47);
  graph.Set('chart.background.grid', true);
  graph.Set('chart.noendxtick', true);
  graph.Set('chart.yaxispos', 'right');
  graph.Set('chart.ymax', 100);
  graph.Set('chart.units.post', 'F');
  graph.Set('chart.title.yaxis', 'Degrees');
  graph.Set('chart.title.xaxis', 'Last 48 Hours');
//  graph.Set('chart.labels', [<? echo implode(',', $idata); ?>]);
  graph.Set('chart.key', ['Temperature', 'Dewpoint', 'Windchill']);
  graph.Set('chart.key.background', 'rgba(255,255,255,0.7)');
  graph.Set('chart.key.position.x', 5);
  graph.Set('chart.key.position.y', 5);
  graph.Set('chart.key.shadow', true);
  graph.Draw();
}

</script>
</body>
</html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link href="include/master.css" rel="stylesheet" type="text/css" />
    </head>


<?php
include("include/connectdb.inc");


$hostname=$_GET["hostname"];
echo "<h1>$hostname</h1>";

function displaySystem($hostname){

	$query="select systems.description as Description, systems.type as Type, operating_systems.name as OS, operating_systems.version as OS_Version from systems JOIN operating_systems ON(systems.os_id=operating_systems.id) where systems.hostname='$hostname';";

	$result=mysql_query($query);

	if($row=mysql_fetch_array($result)){

		echo "<table id=\"infotable\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\">";
   
		$descript	= $row['Description'];
		$type	= $row['Type'];
		$OS = $row['OS'];

	echo "<tr><td class=\"headerinfocell\" colspan=2>General Information</td><tr>";	
	echo "<tr><td class=\"leftInfoCell\">Description</td><td>$descript</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">OS</td><td>$OS</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Type</td><td>$type</td></tr>";

	$query2="SELET * from virtual_systems where hostname='$hostname'";

	$result2=mysql_query($query);

	

	if($row1=mysql_fetch_array($result)){
		$physical_host= $row1['physical_system_hostname'];
		echo "<tr><td class=\"leftInfoCell\">Virtual</td><td>Yes</td></tr>";
		echo "<tr><td class=\"leftInfoCell\">Physical Host</td><td>$physical_host</td></tr>";
	
	}else{
		echo "<tr><td class=\"leftInfoCell\">Virtual</td><td>No</td></tr>";
	}


	echo "</table>";	


}
}

function displayPhysicalHost($hostname){
$query="SELECT * from physical_systems where hostname='$hostname'";

$result=mysql_query($query);

if($row = mysql_fetch_array($result)){
   
	echo "<br><br>";
echo "<table id=\"infotable\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\">";
   
	$serial_number	= $row['serial_number'];
	$cabinet_id	= $row['cabinet_id'];
	$cabinet_position = $row['cabinet_position'];
	$model_id	= $row['model_id'];
 	$asset_tag	= $row['asset_tag'];	

	echo "<tr><td class=\"headerinfocell\" colspan=2>Physical Host</td><tr>";	
	echo "<tr><td class=\"leftInfoCell\">Serial Number</td><td>$serial_number</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Cabinet ID</td><td>$cabinet_id</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Cabinent Position</td><td>$cabinet_position</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Model ID</td><td>$model_id</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Asset Tag</td><td>$asset_tag</td></tr>";
	echo "</table>";
}


}



function displayNetworkInfo($hostname){

	$query="SELECT * from network_addresses where system_hostname='$hostname'";

	$result=mysql_query($query);

	echo "<br><br>";	
	echo "<table id=\"infotable\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\">";
 	echo "<tr><td class=\"headerinfocell\" colspan=3>Network Info</td></tr>";
	echo "<tr><td><b>IP Address</b></td><td><b>FQDN</b></td><td><b>Interface</b></td></tr>";
	  


	while($row=mysql_fetch_array($result)){

		$ip	= $row['ip_address'];
		$fqdn	=	$row['fqdn'];
		$interface = $row['interface'];
	
		echo "<tr><td>$ip</td><td>$fqdn</td><td>$interface</td></tr>";
	
	}
	
	echo "</table>";
}

displaySystem($hostname);
displayNetworkInfo($hostname);
displayPhysicalHost($hostname);
#if virtual get the physical host


?>


</html>

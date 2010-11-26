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

	$query="SELECT physical_systems.serial_number as serial, physical_systems.cabinet_position as position, physical_systems.asset_tag as tag, cabinets.row as rack_row, cabinets.column as rack_column, cabinets.datacenter_name as datacenter from physical_systems Left Join cabinets ON (physical_systems.cabinet_id=cabinets.id) where hostname='$hostname'";

$result=mysql_query($query);

if($row = mysql_fetch_array($result)){
   
	echo "<br><br>";
echo "<table id=\"infotable\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\">";
   
	$serial_number	= $row['serial'];
	$cabinet_position = $row['position'];
 	$asset_tag	= $row['tag'];	
	$cab_row = $row['rack_row'];
	$cab_col = $row['rack_column'];
	$datacenter = $row['datacenter'];	

	echo "<tr><td class=\"headerinfocell\" colspan=2>Physical Host</td><tr>";	
	echo "<tr><td class=\"leftInfoCell\">Serial Number</td><td>$serial_number</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Cabinent Position</td><td>$cabinet_position</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Asset Tag</td><td>$asset_tag</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Rack Location</td><td>$cab_row / $cab_col</td></tr>";
	echo "<tr><td class=\"leftInfoCell\">Datacenter</td><td>$datacenter</td></tr>";
	echo "</table>";
}


}

function displayComments($hostname){

	$query="SELECT * from comments where hostname='$hostname' order by comments.date desc";
	$result=mysql_query($query);

	echo "<br><br>";

	echo "Comments<br>";
	echo "<table id=\"infotable\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\">";

	while($row = mysql_fetch_array($result)){
		$date = $row['date'];
		$admin = $row['admin'];	
		$comment = $row['comment'];
		echo "<tr><td>$date - $admin</td><td>$comment</td></tr>";
	}
	echo "</table>";
 	

}

function displayProject($hostname){

	$query="SELECT systems_projects.project_name as project_name, administrators_projects.administrator_username as admin, administrators_projects.role as role, projects.customer_name as customer_name from systems_projects JOIN projects ON (systems_projects.project_name=projects.name) LEFT JOIN administrators_projects ON (systems_projects.project_name=administrators_projects.project_name) where systems_projects.hostname='$hostname'";
	$result=mysql_query($query);

   	echo "<br><br>";	
	echo "<table id=\"infotable\" cellpadding=\"2\" cellspacing=\"0\" border=\"1\">";
 	echo "<tr><td class=\"headerinfocell\" colspan=4>Associated Projects</td></tr>";
	echo "<tr><td><b>Project Name</b></td><td><b>Customer</b></td><td><b>Admin</b></td><td><b>Role</b></td></tr>";
	
	
	while($row=mysql_fetch_array($result)){
		
		$project_name= $row['project_name'];
		$customer_name= $row['customer_name'];
		$admin = $row['admin'];
		$role = $row['role'];
		echo "<tr><td>$project_name</td><td>$customer_name</td><td>$admin</td><td>$role</td></tr>";
	
	}

	echo "</table>";	


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
displayProject($hostname);
displayComments($hostname);
#if virtual get the physical host


?>


</html>

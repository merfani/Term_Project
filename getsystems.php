<?php
include("include/connectdb.inc");

$title = "Home";
include("include/header.inc");
?>

<?php


echo "</br>";echo "</br>";echo "</br>";
$q=$_GET["q"];
$p=$_GET["p"];
$r=$_GET["r"];

//lookup all hints from array if length of q>0
if (strlen($q) > 0 && strlen($p) > 0 && strlen($r) > 0)
  {
  
  /*
	$con = mysql_connect("76.162.254.152","merfani_cs241","CS241");
	if (!$con)
	{
		die('Could not connect: ' . mysql_error());
	}

	mysql_select_db("merfani_home", $con);
*/
	$sql="SELECT * FROM $p WHERE $r = '".$q."'";

	$result = mysql_query($sql);




echo "<table border='1'><tr>";

$i = 0;
while ($i < mysql_num_fields($result)) {
    $meta = mysql_fetch_field($result, $i);
    if (!$meta) {
        echo "No information available<br />\n";
    }
echo "<th>".$meta->name."</th>";

    $i++;
}

echo "</tr>";

while ($row = mysql_fetch_array($result, MYSQL_NUM)) {
  echo "<tr>";
$k=0;
while ($k < mysql_num_fields($result)) {
echo "<td>" . $row[$k] . "</td>";
$k++;
}

  echo "</tr>";
  }
echo "</table>";

echo "</br></br>";

	$sql="SELECT $p.hostname as Host_Name,
$p.description,
$p.type,
operating_systems.name as OS_Name,
operating_systems.version as OS_Version,
network_addresses.ip_address as IP_Address,
network_addresses.fqdn as Domain_Name,
network_addresses.interface as Network_Interface,
physical_systems.serial_number as System_Serial_Num,
physical_systems.asset_tag as Asset_Tag,
projects.name as Project_Name,
customers.name as Customer_Name,
customers.contact_email as Cutomer_email
FROM $p, operating_systems, network_addresses, physical_systems, systems_projects, projects, customers 
WHERE $p.$r = '".$q."' and
$p.os_id=operating_systems.id and
$p.hostname=network_addresses.system_hostname and
$p.hostname=physical_systems.hostname and
$p.hostname=systems_projects.hostname and
systems_projects.project_name=projects.name and 
projects.customer_name=customers.name";

	$result = mysql_query($sql);




echo "<table border='1'><tr>";

$i = 0;
while ($i < mysql_num_fields($result)) {
    $meta = mysql_fetch_field($result, $i);
    if (!$meta) {
        echo "No information available<br />\n";
    }
echo "<th>".$meta->name."</th>";

    $i++;
}

echo "</tr>";

while ($row = mysql_fetch_array($result, MYSQL_NUM)) {
  echo "<tr>";
$k=0;
while ($k < mysql_num_fields($result)) {
echo "<td>" . $row[$k] . "</td>";
$k++;
}

  echo "</tr>";
  }
echo "</table>";




mysql_free_result($result);

//mysql_close($con);
}
?> 

<?php include("include/footer.inc"); ?>

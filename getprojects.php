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

	$sql="SELECT $p.name as Project_Name, 
	$p.customer_name, 
	customers.contact_email as Customer_email, 
	administrators_projects.role as Admin_role, 
	administrators.name as Admin_name, 
	systems.hostname as Host_Name, 
	systems.description, 
	systems.type as System_Type  
	FROM $p, customers, administrators_projects, administrators, systems_projects, systems 
	WHERE $p.$r = '".$q."' and $p.customer_name=customers.name 
	and $p.name=administrators_projects.project_name 
	and administrators_projects.administrator_username=administrators.username 
	and $p.name=systems_projects.project_name and systems_projects.hostname=systems.hostname";

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

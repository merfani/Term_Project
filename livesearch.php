<?php
include("include/connectdb.inc");

?>

<?php
$q=$_GET["q"];
//lookup all hints from array if length of q>0



//define an array of entities and attributes
$entity[1]="cabinets";$attr[1]="datacenter_name";
$entity[2]="comments";$attr[2]="comment";
$entity[3]="customers";$attr[3]="name";
$entity[4]="datacenter";$attr[4]="name";
$entity[5]="models";$attr[5]="make";
$entity[6]="network_addresses";$attr[6]="ip_address";
$entity[7]="operating_systems";$attr[7]="name";
$entity[8]="physical_systems";$attr[8]="hostname";
$entity[9]="projects";$attr[9]="name";
$entity[10]="systems";$attr[10]="hostname";
$entity[11]="administrators";$attr[11]="name";

$hint="";
$result=0;

if (strlen($q) > 0)
  {
  
  /*
	$con = mysql_connect("76.162.254.152","merfani_cs241","CS241");
	if (!$con)
	{
		die('Could not connect: ' . mysql_error());
	}

	mysql_select_db("merfani_home", $con);
*/
	$mystr=strtoupper($q);




$j=1;

while ($j<=11){

          

                $sql="SELECT * FROM ".$entity[$j]." WHERE upper(".$attr[$j].") like '".$mystr."%'";

	$result = mysql_query($sql);

                if ($result){


                     while ($row = mysql_fetch_array($result)) {
                         $str=printf( "<a href=\"http://www.sepaas.com/cs241/get%s.php?q=%s&p=%s&r=%s\">%s</a>",$entity[$j],
$row[$attr[$j]],$entity[$j],$attr[$j],$row[$attr[$j]]); printf(" in %s", $entity[$j]);
                         echo "</br>";
                         $hint="true";
                     }
                         mysql_free_result($result);

                 }

$j++;

}






  

// Set output to "no suggestion" if no hint were found
// or to the correct values
if ($hint == "")
  {
  $response="no suggestion";
  echo $response;
  }

  
//mysql_close($con);
}
?> 
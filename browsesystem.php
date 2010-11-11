<?php
include("include/connectdb.inc");
include("include/utils.inc");


$title = "Browse System";
$javascript = "include/addsystem.js";

$types = "";

if (isset($_REQUEST["server_type"])){
    $type = $_REQUEST["server_type"];
    $num_types = count($type); 
}
else{
    $type = "";
    $num_types = 0;
}


echo "<h1>NUMTYPES: $num_types</h1>";

if (isset($_REQUEST["os_type"])){
    $os = $_REQUEST["os_type"];
    $num_os = count($os);
}
else{
    $os = "";
    $num_os = 0; 
}


include("include/header.inc");
?>

<form method="post" action="browsesystem.php">
<table id="displayTable" class="formtable">
<tr>
    <td colspan="2"><div class="formtitle">Browse Systems</div></td>
</tr>
<tr>
    <td id="typetd">
    <div>Types</div>    
    <?php
                $types = gettypes();
                
               # echo "<div style=\"height: 100px width: 200px; overflow: scroll;\">";
               # foreach($types as $t){
                #    echo "<input id=\"$t\" type=\"checkbox\" name=\"server_type[]\"/>";
                #    echo "<label for=\"$t\">$t</label><br>";
               # }

                 echo "<select name=\"server_type[]\" size=\"5\" MULTIPLE>\n";
                echo "<option SELECTED>Not Specified</option>\n";
                foreach ($types as $t) {
                    echo "<option>$t</option>\n";
                }
                echo "</select>\n";

                
         ?>
     </td>
        <td id="ostd">
            <div>OS</div>    
            <?php
                $oses = getoses();
                echo "<select name=\"os_type[]\" size=\"5\" multiple=\"yes\">\n";
                echo "<option SELECTED>Not Specified</option>\n";
                foreach ($oses as $t) {
                    echo "<option>$t</option>\n";
                }
                echo "</select>\n";

               
                ?>
            </td>

    <td>
        <input type="submit" value="search">
    </td>
</tr>
</table>

<?php

if($num_types != 0){
    
    echo "Displaying Results<br>";
    echo "<table id=resultsTable class=\"formtable\">";

    //escape each element of the array
  /* $arr = array();

    $i=0;
    //get the number of selected types
    foreach ($type as $t){
        if($t == "on"){
            array_push($arr, $types[$i]);
        }
        $i++;
    } 
    */

    $type_mysql = "type='" . implode("' or type='", $type) . "'";
 

    $query = "SELECT * from systems where $type_mysql";

    echo "QUERY: $query";

    $result = mysql_query($query);

    echo "<tr><td>Hostname</td><td>Description</td><td>Type</td><td>OS ID</td></tr>";

    while($row = mysql_fetch_array($result)){
        echo "<tr>";
        $hostname       =   $row['hostname'];
        $description    =   $row['description'];
        $type           =   $row['type'];
        $os_id          =   $row['os_id'];
        echo "<td>$hostname</td>";
        echo "<td>$description</td>";
        echo "<td>$type</td>";
        echo "<td>$os_id</td>";
        echo "</tr>";
    }
   
     echo "</table>";

   
    mysql_free_result($result);
}

?>
<?php include("include/footer.inc"); ?>

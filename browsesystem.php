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



if (isset($_REQUEST["os_type"])){
    $os = $_REQUEST["os_type"];
    $num_os = count($os);
}
else{
    $os = "";
    $num_os = 0; 
}

if (isset($_REQUEST["results_limit"])){
    $display_limit=$_REQUEST["results_limit"];
}
else{
    $display_limit=25;
}


$display_index=0;
include("include/header.inc");
?>

<table id="mainTable" class="browseTableStyle">
<tr><td>

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

        <input type="radio" name="results_limit" value="25" <?php if($display_limit == 25){echo "checked";} ?>/>25<br />
        <input type="radio" name="results_limit" value="50" <?php if($display_limit == 50){echo "checked";} ?>/>50<br />
        <input type="radio" name="results_limit" value="100" <?php if($display_limit == 100){echo "checked";} ?>/>100<br />
    
    </td> 
    <td>
        <input type="submit" value="search">
    </td>
</tr>
</table>
</form>
</td></tr> 

<?php

if($num_types != 0){
   
    

   $type_mysql = "systems.type='" . implode("' or systems.type='", $type) . "'";
 
    $order_field = "Hostname";
    $order_direction = "asc";
    $upper_limit= $display_index + $display_limit;
    $query = "SELECT SQL_CALC_FOUND_ROWS systems.hostname as Hostname,
                                         systems.description as Description,
                                         systems.type as Type,
                                         operating_systems.name as OS,
                                         operating_systems.version as Version
                 from systems JOIN operating_systems ON (systems.os_id=operating_systems.id)
                        where $type_mysql order by $order_field $order_direction
         limit $display_index, $upper_limit";

    echo "QUERY: $query";

    $result = mysql_query($query);

    $num_rows = mysql_num_rows($result);

    $num_result = mysql_query("SELECT FOUND_ROWS()");

    $total_num_rows = mysql_result($num_result, 0);    

    $start_index=$display_index+1;
    $end_index=$display_index+$num_rows;

   echo "<tr><td>";
    echo "<table id=\"results\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\" class=\"resultstyle\">";
    echo "Displaying $start_index-$end_index from a total of  $total_num_rows results";
 
    
 
    echo "<tr id=\"resultFields\">";
    while( $property = mysql_fetch_field($result) ){
        echo "<td><b>$property->name</b></td>";
    }
    echo "<td />"; 
    echo "</tr>";
     while($row = mysql_fetch_array($result)){
        echo "<tr>";
        $hostname       =   $row['Hostname'];        
        $description    =   $row['Description'];
        $type           =   $row['Type'];
        $os_id          =   $row['OS'];
        $version        =   $row['Version'];
        echo "<td>$hostname</td>";
        echo "<td>$description</td>";
        echo "<td>$type</td>";
        echo "<td>$os_id</td>";
        echo "<td>$version</td>";
        echo "<td><a href=\"\">+</a></td></tr>";


    }
   
     echo "</td></tr></table></tr>";

   
    mysql_free_result($result);
}

?>
</table>
<?php include("include/footer.inc"); ?>

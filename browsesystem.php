<?php
include("include/connectdb.inc");
include("include/utils.inc");

function isSelected($array, $item)
{

    foreach ($array as $val){
        if($val == $item) return "SELECTED";
    }
    return "";

}

function removeNotSpecified(&$array){
    
    foreach ($array as $i => $value) {
        if($value == "Not Specified"){
            unset($array[$i]);
            return;
        }
    }    
        
}


$title = "Browse System";

$type = array();
$num_types = 0;
if (isset($_REQUEST["server_type"])){
    $type = $_REQUEST["server_type"];
    removeNotSpecified($type);
    $num_types = count($type); 
}

if (isset($_REQUEST["os_type"])){
    $os = $_REQUEST["os_type"];
    removeNotSpecified($os);
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


if (isset($_REQUEST["start_index"])){
    $display_index = $_REQUEST["start_index"];
}else{

    $display_index=0;
}

if (isset($_REQUEST["order_field"])){
$order_field=$_REQUEST["order_field"];
}else{
	$order_field="Hostname";
}

if (isset($_REQUEST["order_direction"])){
	$order_direction=$_REQUEST["order_direction"];
}else{
	$order_direction="asc";
}

$show_results=0;	#default, so it does not search first time

if (isset($_REQUEST["first_load"])){
	$show_results=$_REQUEST["first_load"];	
}

if (isset($_REQUEST["submitbutton"])){
	$display_index=0;
	$show_results=1;
}


include("include/header.inc");
?>

<table id="mainTable" class="browseTableStyle">
<tr><td>

<form method="post" id="myform" name="myform" action="browsesystem.php">
<table id="displayTable" class="formtable">
<tr>
    <td colspan="2"><div class="formtitle">Browse Systems</div></td>
</tr>
<tr>
    <td id="typetd">
    <div>Types</div>    
    <?php
                $types = gettypes();
                echo "<select name=\"server_type[]\" size=\"5\" MULTIPLE>\n";
                
                if($num_types==0){
                    echo "<option \"SELECTED\">Not Specified</option>";
                }else{
                    echo "<option>Not Specified</option>";
                }

                  foreach ($types as $t) {
                      $select = isSelected($type, $t);
                     echo "<option $select>$t</option>\n";
                }
                echo "</select>\n";

                
         ?>
     </td>
     <td id="ostd">
            <div>OS</div>    
            <?php
                $oses = getos();
                echo "<select name=\"os_type[]\" size=\"5\" multiple=\"yes\">\n";
                if($num_os==0){
                    echo "<option \"SELECTED\">Not Specified</option>";
                }else{
                    echo "<option>Not Specified</option>";
                }


                foreach ($oses as $t) {
                    $select = isSelected($os, $t);
                    echo "<option $select>$t</option>\n";
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
	<input type="hidden" name="first_load" value="<?php echo "$show_results"; ?>">
        <input type="hidden" name="order_direction" value="<?php echo "$order_direction"; ?>">
        <input type="hidden" name="order_field" value="<?php echo "$order_field"; ?>"> 
        <input type="hidden" name="start_index" value="<?php echo "$display_index"; ?>">
        <input type="submit" name="submitbutton" value="search">
    </td>
</tr>
</table>
</form>
</td></tr> 

<script type="text/javascript" language="Javascript" src="include/browsesystem.js"></script>

<?php

    if($show_results == 1){
    if($num_types != 0){
        $type_mysql = "systems.type='" . implode("' or systems.type='", $type) . "'";
    }else{
        $type_mysql = "systems.type IS NOT NULL";
    }  

    if($num_os != 0){
        $type_os = "operating_systems.name='" . implode("' or operating_systems.name='", $os) . "'"; 
    }else{
        $type_os = "operating_systems.name IS NOT NULL";
    }

    $query = "SELECT SQL_CALC_FOUND_ROWS systems.hostname as Hostname,
                                         systems.description as Description,
                                         systems.type as Type,
                                         operating_systems.name as OS,
                                         operating_systems.version as Version
                 from systems JOIN operating_systems ON (systems.os_id=operating_systems.id)
                        where (($type_mysql) AND ($type_os)) order by $order_field $order_direction
         limit $display_index, $display_limit";

      $result = mysql_query($query);

    $num_rows = mysql_num_rows($result);

    $num_result = mysql_query("SELECT FOUND_ROWS()");

    $total_num_rows = mysql_result($num_result, 0);    

    $start_index=$display_index+1;
    $end_index=$display_index+$num_rows;
    
    if($num_rows > 0){
	
	echo "<tr><td>";
	echo "<table width=\"100%\"><tr><style type=\"text/css\"> td.jump {text-align: right}</style>";
      	echo "<td>Displaying $start_index-$end_index from a total of  $total_num_rows results</td>";
    	echo "<td class=\"jump\">";
        
	if($display_index != 0){
     
	   	$newIndex = $display_index - $display_limit;
        	echo "<a href=\"javascript: submitform($newIndex)\">Prev</a>"; 
        
		if($end_index < $total_num_rows){echo "|";}
    	}
   
	if($end_index < $total_num_rows){
        	
		echo "<a href=\"javascript: submitform($end_index)\"> Next</a>";
    	}
    
	echo "</td>";
    	echo "</tr></table>";
	echo "</tr></td>";
    	echo "<tr><td>";
	echo "<table id=\"results\" cellpadding=\"3\" cellspacing=\"0\" border=\"1\" class=\"resultstyle\">";
    
 
    echo "<tr id=\"resultFields\">";
    while( $property = mysql_fetch_field($result) ){
        echo "<td><b><a href =\"javascript: submitorder('$property->name')\">$property->name</a></b></td>";
    }
    echo "</tr>";



    while($row = mysql_fetch_array($result)){
        echo "<tr>";
        $hostname       =   $row['Hostname'];        
        $description    =   $row['Description'];
        $type           =   $row['Type'];
        $os_id          =   $row['OS'];
        $version        =   $row['Version'];

  	echo "<td><a href=\"Javascript:newPopup('entryinfo.php?hostname=$hostname');\">$hostname</a></td>";
        echo "<td>$description</td>";
        echo "<td>$type</td>";
        echo "<td>$os_id</td>";
        echo "<td>$version</td>";
      
        echo "</tr>";


    }
   
     echo "</table>";
     echo "</td></tr>";
    echo "<tr><td>QUERY FOR DEMO PURPOSES: $query </td></tr>";
   }
    


	mysql_free_result($result);

   }
?>
</table>
<?php include("include/footer.inc"); ?>

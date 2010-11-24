<?php
include("include/connectdb.inc");
include("include/utils.inc");

$hostname = "";
$hostnameerror = "";

$description = "";
$descriptionerror = "";

$type = "";
$typeerror = "";

$os = "";
$osname = "";
$osversion = "";
$oserror = "";

$virtualization = "";
$virtualizationerror = "";

$serialnumber = "";
$serialnumbererror = "";

$assettag = "";
$assettagerror = "";

$model = "";
$modelmake = "";
$modelmodel = "";
$modelheight = "";
$modelerror = "";

$datacenter = "";
$datacentername = "";
$datacenteraddress = "";
$datacentererror = "";

$cabinet = "";
$cabinetrow = "";
$cabinetcolumn = "";
$cabineterror = "";

$cabinetposition = "";
$cabinetpositionerror = "";

$host = "";
$hosterror = "";

if (isset($_REQUEST["action"]) && $_REQUEST["action"] == "post") {
    $error = false;

    if (isset($_REQUEST["hostname"]))
        $hostname = $_REQUEST["hostname"];

    # check that the hostname is valid
    if (!preg_match("/[a-z][a-z0-9-]*/", $hostname)) {
        $hostnameerror =  "Invalid hostname.";
        $error = true;
    }

    # check that the system doesn't already exist
    $query = sprintf("SELECT * FROM systems WHERE hostname='%s'", mysql_real_escape_string($hostname));
    $result = mysql_query($query);
    if (mysql_num_rows($result) != 0) {
        $hostnameerror = "Hostname exists.";
        $error = true;
    }

    if (isset($_REQUEST["description"]))
        $description = $_REQUEST["description"];

    # check that the description is present
    if (strlen($description) == 0) {
        $descriptionerror = "Required.";
        $error = true;
    }

    if (isset($_REQUEST["type"]))
        $type = $_REQUEST["type"];

    # check that the type is present
    if (strlen($type) == 0) {
        $typeerror = "Required.";
        $error = true;
    }

    if (isset($_REQUEST["os"]))
        $os = $_REQUEST["os"];

    if (isset($_REQUEST["osname"]))
        $osname = $_REQUEST["osname"];
   
    if (isset($_REQUEST["osversion"]))
        $osversion = $_REQUEST["osversion"];

    if (strlen($os) == 0) {
        if (strlen($osname) == 0 || strlen($osversion) == 0) {
            $oserror = "Required.";
            $error = true;
        }

        $query = sprintf("SELECT id FROM operating_systems WHERE name='%s' AND version='%s'",
            mysql_real_escape_string($osname),
            mysql_real_escape_string($osversion));
        $result = mysql_query($query);

        if ($row = mysql_fetch_assoc($result))
            $os = $row["id"];
    }

    if (isset($_REQUEST["virtualization"]))
        $virtualization = $_REQUEST["virtualization"];

    if ($virtualization != "physical" && $virtualization != "virtual") {
        $virtualizationerror = "Required.";
        $error = true;
    }

    if ($virtualization == "physical") {
        if (isset($_REQUEST["model"]))
            $model = $_REQUEST["model"];

        if (isset($_REQUEST["modelmake"]))
            $modelmake = $_REQUEST["modelmake"];

        if (isset($_REQUEST["modelmodel"]))
            $modelmodel = $_REQUEST["modelmodel"];

        if (isset($_REQUEST["modelheight"]))
            $modelheight = $_REQUEST["modelheight"];

        if (strlen($model) == 0) {
            if (!($modelheight > 0)) {
                $modelerror = "Invalid height.";
                $error = true;
            }

            if (strlen($modelmake) == 0 || strlen($modelmodel) == 0 || strlen($modelheight) == 0) {
                $modelerror = "Required.";
                $error = true;
            }

            $query = sprintf("SELECT id FROM models WHERE make='%s' AND model='%s'",
                mysql_real_escape_string($modelmake),
                mysql_real_escape_string($modelmodel));
            $result = mysql_query($query);

            if ($row = mysql_fetch_assoc($result))
                $model = $row["id"];
        }

        if (isset($_REQUEST["serialnumber"]))
            $serialnumber = $_REQUEST["serialnumber"];

        if (strlen($serialnumber) == 0) {
            $serialnumbererror = "Required.";
            $error = true;
        }

        if (isset($_REQUEST["assettag"]))
            $assettag = $_REQUEST["assettag"];

        if (strlen($assettag) == 0) {
            $assettagerror = "Required.";
            $error = true;
        }

        if (isset($_REQUEST["datacenter"]))
            $datacenter = $_REQUEST["datacenter"];

        if (isset($_REQUEST["datacentername"]))
            $datacentername = $_REQUEST["datacentername"];

        if (isset($_REQUEST["datacenteraddress"]))
            $datacenteraddress = $_REQUEST["datacenteraddress"];

        if (strlen($datacenter) == 0) {
            if (strlen($datacentername) == 0 || strlen($datacenteraddress) == 0) {
                $datacentererror = "Required.";
                $error = true;
            }

            $query = sprintf("SELECT name FROM datacenter WHERE name='%s'", mysql_real_escape_string($datacentername));
            $result = mysql_query($query);

            if ($row = mysql_fetch_assoc($result))
                $datacenter = $row["name"];
        }

        if (isset($_REQUEST["cabinet"]))
            $cabinet = $_REQUEST["cabinet"];

        if (isset($_REQUEST["cabinetrow"]))
            $cabinetrow = $_REQUEST["cabinetrow"];

        if (isset($_REQUEST["cabinetcolumn"]))
            $cabinetcolumn = $_REQUEST["cabinetcolumn"];

        if (strlen($cabinet) == 0) {
            if (strlen($cabinetrow) == 0 || strlen($cabinetcolumn) == 0) {
                $cabineterror = "Required.";
                $error = true;
            }

            $query = sprintf("SELECT id FROM cabinets WHERE `row`='%s' AND `column`='%s' AND datacenter_name='%s'",
                mysql_real_escape_string($cabinetrow),
                mysql_real_escape_string($cabinetcolumn),
                mysql_real_escape_string($datacenter));
            $result = mysql_query($query);

            if ($row = mysql_fetch_assoc($result))
                $cabinet = $row["id"];
        }

        if (isset($_REQUEST["cabinetposition"]))
            $cabinetposition = $_REQUEST["cabinetposition"];

        if (!is_numeric($cabinetposition) || !($cabinetposition >= 0 && $cabinetposition <= 40)) {
            $cabinetpositionerror = "Must be between 0 and 40.";
            $error = true;
        }
    }

    if ($virtualization == "virtual") {
        if (isset($_REQUEST["host"]))
            $host = $_REQUEST["host"];

        if (strlen($host) == 0) {
            $hosterror = "Required.";
            $error = true;
        }
    }

    if (!$error) {
        if (strlen($os) == 0) {
            $query = sprintf("INSERT INTO operating_systems (name, version) VALUES ('%s', '%s')",
                mysql_real_escape_string($osname),
                mysql_real_escape_string($osversion));
            mysql_query($query);
            $os = mysql_insert_id();
        }

        $query = sprintf("INSERT INTO types VALUES ('%s')", mysql_real_escape_string($type));
        mysql_query($query);

        $query = sprintf("INSERT INTO systems VALUES ('%s', '%s', '%s', '%d')",
            mysql_real_escape_string($hostname),
            mysql_real_escape_string($description),
            mysql_real_escape_string($type),
            mysql_real_escape_string($os));
        mysql_query($query);

        if ($virtualization == "physical") {
            if (strlen($model) == 0) {
                $query = sprintf("INSERT INTO models (make, model, height) VALUES ('%s', '%s', '%d')",
                    mysql_real_escape_string($modelmake),
                    mysql_real_escape_string($modelmodel),
                    mysql_real_escape_string($modelheight));
                mysql_query($query);
                $model = mysql_insert_id();
            }

            if (strlen($datacenter) == 0) {
                $query = sprintf("INSERT INTO datacenter VALUES ('%s', '%s')",
                    mysql_real_escape_string($datacentername),
                    mysql_real_escape_string($datacenteraddress));
                mysql_query($query);
                $datacenter = $datacentername;
            }

            if (strlen($cabinet) == 0) {
                $query = sprintf("INSERT INTO cabinets (`row`, `column`, datacenter_name) VALUES ('%s', '%s', '%s')",
                    mysql_real_escape_string($cabinetrow),
                    mysql_real_escape_string($cabinetcolumn),
                    mysql_real_escape_string($datacenter));
                mysql_query($query);
                $cabinet = mysql_insert_id();
            }

            $query = sprintf("INSERT INTO physical_systems VALUES ('%s', '%s', '%d', '%d', '%d', '%s')",
                mysql_real_escape_string($hostname),
                mysql_real_escape_string($serialnumber),
                mysql_real_escape_string($cabinet),
                mysql_real_escape_string($cabinetposition),
                mysql_real_escape_string($model),
                mysql_real_escape_string($assettag));
            mysql_query($query);
        }

        if ($virtualization == "virtual") {
            $query = sprintf("INSERT INTO virtual_systems VALUES ('%s', '%s')",
                mysql_real_escape_string($hostname),
                mysql_real_escape_string($host));
            mysql_query($query);
        }
    }
}

$title = "Add System";
$javascript = "include/addsystem.js";
include("include/header.inc");
?>

<form method="post" action="addsystem.php">
    <table id="formtable" class="formtable">
        <tr><td colspan="2"><div class="formtitle">Add System</div></td></tr>
    
        <tr>
            <td>Hostname</td>
            <td><input type="text" name="hostname" value="<?php echo $hostname ?>" /> <?php echo $hostnameerror ?></td>
        </tr>

        <tr>
            <td>Description</td>
            <td><input type="text" name="description" value="<?php echo $description ?>" /> <?php echo $descriptionerror ?></td>
        </tr>

        <tr>
            <td>Type</td>
            <td id="typetd">
                <?php
                $types = gettypes();
                if (count($types) == 0 || strlen($type) != 0) {
                    echo "<input type=\"text\" name=\"type\" value=\"$type\" />\n";
                } else {
                    echo "<select name=\"type\">\n";
                    foreach ($types as $t) {
                        echo "<option" . ($type == $t ? " selected=\"selected\"" : "") . ">$t</option>\n";
                    }
                    echo "</select>\n";
                    echo "<a id=\"addtype\" href=\"javascript:void(0)\">New...</a>\n";
                }
                echo $typeerror;
                ?>
            </td>
        </tr>

        <tr>
            <td>OS</td>
            <td id="ostd">
                <?php
                $oses = getoses();
                if (count($oses) == 0 || strlen($osname) != 0 || strlen($osversion) != 0) {
                    echo "Name <input type=\"text\" size=\"14\" name=\"osname\" value=\"$osname\" />\n";
                    echo "Version <input type=\"text\" size=\"5\" name=\"osversion\" value=\"$osversion\" />\n";
                } else {
                    echo "<select name=\"os\">\n";
                    foreach ($oses as $osid => $o) {
                        echo "<option" . ($os == $osid ? " selected=\"selected\"" : "") . " value=\"$osid\">$o</option>\n";
                    }
                    echo "</select>\n";
                    echo "<a id=\"addos\" href=\"javascript:void(0);\">New...</a>\n";
                }
                echo $oserror;
                ?>
            </td>
        </tr>

        <tr>
            <td>Virtualization</td>
            <td>
                <input id="physical" type="radio" name="virtualization" value="physical" <?php if ($virtualization == "physical") echo "checked=\"checked\"" ?>>Physical</input>
                <input id="virtual" type="radio" name="virtualization" value="virtual" <?php if ($virtualization == "virtual") echo "checked=\"checked\"" ?>>Virtual</input>
                <?php echo $virtualizationerror ?>
            </td>
        </tr>
        
        <?php
        if ($virtualization == "physical")
            echo getphysicalhtml($serialnumber, $serialnumbererror, $assettag, $assettagerror, $model, $modelmake, $modelmodel, $modelheight, $modelerror, $datacenter, $datacentername, $datacenteraddress, $datacentererror, $cabinet, $cabinetrow, $cabinetcolumn, $cabineterror, $cabinetposition, $cabinetpositionerror);
        else if ($virtualization == "virtual")
            echo getvirtualhtml($host, $hosterror);
        ?>
    </table>
    <div class="formsubmit">
        <input type="hidden" name="action" value="post" />
        <input type="submit" value="Add" />
    </div>
</form>

<?php include("include/footer.inc"); ?>

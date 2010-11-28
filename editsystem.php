<?php
include("include/connectdb.inc");
include("include/utils.inc");

if (isset($_REQUEST["hostname"]))
    $hostname = $_REQUEST["hostname"];
else
    die("Hostname required.");

$query = sprintf("SELECT * FROM systems WHERE hostname='%s'", mysql_real_escape_string($hostname));
$result = mysql_query($query);

if (!$row = mysql_fetch_assoc($result))
    die("Invalid hostname.");

$description = $row["description"];
$descriptionerror = "";

$type = $row["type"];
$typeerror = "";

$os = $row["os_id"];
$osname = "";
$osversion = "";
$oserror = "";

$query = sprintf("SELECT * FROM physical_systems INNER JOIN cabinets ON physical_systems.cabinet_id=cabinets.id WHERE hostname='%s'", mysql_real_escape_string($hostname));
$result = mysql_query($query);

if (!$row = mysql_fetch_assoc($result)) {
    $query = sprintf("SELECT * FROM virtual_systems WHERE hostname='%s'", mysql_real_escape_string($hostname));
    $result = mysql_query($query);

    if (!$row = mysql_fetch_assoc($result))
        die("Invalid virtualization type.");

    $virtualization = "virtual";
} else
    $virtualization = "physical";

$oldvirtualization = $virtualization;
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

if ($virtualization == "physical") {
    $serialnumber = $row["serial_number"];
    $assettag = $row["asset_tag"];
    $model = $row["model_id"];
    $datacenter = $row["datacenter_name"];
    $cabinet = $row["cabinet_id"];
    $cabinetposition = $row["cabinet_position"];
} else {
    $host = $row["physical_system_hostname"];
}

if (isset($_REQUEST["action"]) && $_REQUEST["action"] == "post") {
    $error = false;

    $newdescription = "";
    if (isset($_REQUEST["description"]))
        $newdescription = $_REQUEST["description"];

    # check that the description is present
    if (strlen($newdescription) == 0) {
        $descriptionerror = "Required.";
        $error = true;
    } else
        $description = $newdescription;

    $newtype = "";
    if (isset($_REQUEST["type"]))
        $newtype = $_REQUEST["type"];

    # check that the type is present
    if (strlen($newtype) == 0) {
        $typeerror = "Required.";
        $error = true;
    } else
        $type = $newtype;

    $newos = "";
    if (isset($_REQUEST["os"]))
        $newos = $_REQUEST["os"];

    $newosname = "";
    if (isset($_REQUEST["osname"]))
        $newosname = $_REQUEST["osname"];
  
    $newosversion = ""; 
    if (isset($_REQUEST["osversion"]))
        $newosversion = $_REQUEST["osversion"];

    if (strlen($newos) == 0) {
        if (strlen($newosname) == 0 || strlen($newosversion) == 0) {
            $oserror = "Required.";
            $error = true;
        } else {
            $osname = $newosname;
            $osverion = $newosversion;
        }

        $query = sprintf("SELECT id FROM operating_systems WHERE name='%s' AND version='%s'",
            mysql_real_escape_string($newosname),
            mysql_real_escape_string($newosversion));
        $result = mysql_query($query);

        if ($row = mysql_fetch_assoc($result))
            $newos = $row["id"];
    } 
    $os = $newos;

    $newvirtualization = "";
    if (isset($_REQUEST["virtualization"]))
        $newvirtualization = $_REQUEST["virtualization"];

    $is_hosting = false;
    if ($oldvirtualization == "physical" && $newvirtualization == "virtual") {
        $query = sprintf("SELECT hostname FROM virtual_systems WHERE physical_system_hostname='%s'", mysql_real_escape_string($hostname));
        $result = mysql_query($query);
        $is_hosting = mysql_num_rows($result) != 0;
    }

    if ($newvirtualization != "physical" && $newvirtualization != "virtual") {
        $virtualizationerror = "Required.";
        $error = true;
    } else if ($is_hosting) {
        $virtualizationerror = "This system hosts other systems.";
        $error = true;
    } else
        $virtualization = $newvirtualization;

    if ($virtualization == "physical") {
        $newmodel = "";
        if (isset($_REQUEST["model"]))
            $newmodel = $_REQUEST["model"];

        $newmodelmake = "";
        if (isset($_REQUEST["modelmake"]))
            $newmodelmake = $_REQUEST["modelmake"];

        $newmodelmodel = "";
        if (isset($_REQUEST["modelmodel"]))
            $newmodelmodel = $_REQUEST["modelmodel"];

        $newmodelheight = "";
        if (isset($_REQUEST["modelheight"]))
            $newmodelheight = $_REQUEST["modelheight"];

        if (strlen($newmodel) == 0) {
            if (!($newmodelheight > 0)) {
                $modelerror = "Invalid height.";
                $error = true;
            } else 
                $modelheight = $newmodelheight;

            if (strlen($newmodelmake) == 0 || strlen($newmodelmodel) == 0 || strlen($newmodelheight) == 0) {
                $modelerror = "Required.";
                $error = true;
            } else {
                $modelmake = $newmodelmake;
                $modelmodel = $newmodelmodel;
                $modelheight = $newmodelheight;
            }

            $query = sprintf("SELECT id FROM models WHERE make='%s' AND model='%s'",
                mysql_real_escape_string($newmodelmake),
                mysql_real_escape_string($newmodelmodel));
            $result = mysql_query($query);

            if ($row = mysql_fetch_assoc($result))
                $newmodel = $row["id"];
        }
        $model = $newmodel;

        $newserialnumber = "";
        if (isset($_REQUEST["serialnumber"]))
            $newserialnumber = $_REQUEST["serialnumber"];

        if (strlen($newserialnumber) == 0) {
            $serialnumbererror = "Required.";
            $error = true;
        } else
            $serialnumber = $newserialnumber;

        $newassettag = "";
        if (isset($_REQUEST["assettag"]))
            $newassettag = $_REQUEST["assettag"];

        if (strlen($newassettag) == 0) {
            $assettagerror = "Required.";
            $error = true;
        } else
            $assettag = $newassettag;

        $newdatacenter = "";
        if (isset($_REQUEST["datacenter"]))
            $newdatacenter = $_REQUEST["datacenter"];

        $newdatacentername = "";
        if (isset($_REQUEST["datacentername"]))
            $newdatacentername = $_REQUEST["datacentername"];

        $newdatacenteraddress = "";
        if (isset($_REQUEST["datacenteraddress"]))
            $newdatacenteraddress = $_REQUEST["datacenteraddress"];

        if (strlen($newdatacenter) == 0) {
            if (strlen($newdatacentername) == 0 || strlen($newdatacenteraddress) == 0) {
                $datacentererror = "Required.";
                $error = true;
            } else { 
                $datacentername = $newdatacentername;
                $datacenteraddress = $newdatacenteraddress;
            }

            $query = sprintf("SELECT name FROM datacenter WHERE name='%s'", mysql_real_escape_string($newdatacentername));
            $result = mysql_query($query);

            if ($row = mysql_fetch_assoc($result))
                $newdatacenter = $row["name"];
        }
        $datacenter = $newdatacenter;

        $newcabinet = "";
        if (isset($_REQUEST["cabinet"]))
            $newcabinet = $_REQUEST["cabinet"];

        $newcabinetrow = "";
        if (isset($_REQUEST["cabinetrow"]))
            $newcabinetrow = $_REQUEST["cabinetrow"];

        $newcabinetcolumn = "";
        if (isset($_REQUEST["cabinetcolumn"]))
            $newcabinetcolumn = $_REQUEST["cabinetcolumn"];

        if (strlen($newcabinet) == 0) {
            if (strlen($newcabinetrow) == 0 || strlen($newcabinetcolumn) == 0) {
                $cabineterror = "Required.";
                $error = true;
            } else {
                $cabinetrow = $newcabinetrow;
                $cabinetcolumn = $newcabinetcolumn;
            }

            $query = sprintf("SELECT id FROM cabinets WHERE `row`='%s' AND `column`='%s' AND datacenter_name='%s'",
                mysql_real_escape_string($newcabinetrow),
                mysql_real_escape_string($newcabinetcolumn),
                mysql_real_escape_string($datacenter));
            $result = mysql_query($query);

            if ($row = mysql_fetch_assoc($result))
                $newcabinet = $row["id"];
        }
        $cabinet = $newcabinet;

        $newcabinetposition = 0;
        if (isset($_REQUEST["cabinetposition"]))
            $newcabinetposition = $_REQUEST["cabinetposition"];

        if (!is_numeric($newcabinetposition) || !($newcabinetposition >= 0 && $newcabinetposition <= 40)) {
            $cabinetpositionerror = "Must be between 0 and 40.";
            $error = true;
        } else
            $cabinetposition = $newcabinetposition;
    }

    if ($virtualization == "virtual") {
        $newhost = "";
        if (isset($_REQUEST["host"]))
            $newhost = $_REQUEST["host"];

        if (strlen($newhost) == 0) {
            $hosterror = "Required.";
            $error = true;
        } else
            $host = $newhost;
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

        $query = sprintf("UPDATE systems SET description='%s', type='%s', os_id='%d' WHERE hostname='%s'",
            mysql_real_escape_string($description),
            mysql_real_escape_string($type),
            mysql_real_escape_string($os),
            mysql_real_escape_string($hostname));
        mysql_query($query) or die(mysql_error());

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

            if ($oldvirtualization == "virtual") {
                $query = sprintf("INSERT INTO physical_systems VALUES ('%s', '%s', '%d', '%d', '%d', '%s')",
                    mysql_real_escape_string($hostname),
                    mysql_real_escape_string($serialnumber),
                    mysql_real_escape_string($cabinet),
                    mysql_real_escape_string($cabinetposition),
                    mysql_real_escape_string($model),
                    mysql_real_escape_string($assettag));
                mysql_query($query);

                $query = sprintf("DELETE FROM virtual_systems WHERE hostname='%s'", mysql_real_escape_string($hostname));
                mysql_query($query);
            } else {
                $query = sprintf("UPDATE physical_systems SET serial_number='%s', cabinet_id='%d', cabinet_position='%d', model_id='%d', asset_tag='%s' WHERE hostname='%s'",
                    mysql_real_escape_string($serialnumber),
                    mysql_real_escape_string($cabinet),
                    mysql_real_escape_string($cabinetposition),
                    mysql_real_escape_string($model),
                    mysql_real_escape_string($assettag),
                    mysql_real_escape_string($hostname));
                mysql_query($query);
            }
        }

        if ($virtualization == "virtual") {
            if ($oldvirtualization == "physical") {
                $query = sprintf("INSERT INTO virtual_systems VALUES ('%s', '%s')",
                    mysql_real_escape_string($hostname),
                    mysql_real_escape_string($host));
                mysql_query($query);

                $query = sprintf("DELETE FROM physical_systems WHERE hostname='%s'", mysql_real_escape_string($hostname));
                mysql_query($query);
            } else {
                $query = sprintf("UPDATE virtual_systems SET physical_system_hostname='%s' WHERE hostname='%s'",
                    mysql_real_escape_string($host),
                    mysql_real_escape_string($hostname));
                mysql_query($query);
            }
        }

        # redirect to entryinfo upon insertion success
        $host = $_SERVER['HTTP_HOST'];
        $uri = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
        $extra = "entryinfo.php?hostname=" . urlencode($hostname);
        header("Location: http://$host$uri/$extra");
        exit;
    }
}

$title = "Edit System";
$javascript = "include/addsystem.js";
include("include/header.inc");
?>

<form method="post" action="editsystem.php">
    <table id="formtable" class="formtable">
        <tr><td colspan="2"><div class="formtitle">Edit System</div></td></tr>
    
        <tr>
            <td>Hostname</td>
            <td><input type="text" name="hostname" value="<?php echo $hostname ?>" readonly="readonly" /></td>
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
                if (count($types) == 0 || (!in_array($type, $types) && strlen($type) != 0)) {
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

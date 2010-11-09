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
    }
}

$title = "Add System";
$javascript = "include/addsystem.js";
include("include/header.inc");
?>

<form method="post" action="addsystem.php">
    <table class="formtable">
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
                if (count($types) == 0) {
                    echo "<input type=\"text\" name=\"type\" value=\"$type\" />\n";
                } else {
                    echo "<select name=\"type\">\n";
                    foreach ($types as $t) {
                        echo "<option" . ($type == $t ? " selected=\"selected\"" : "") . ">$t</option>\n";
                    }
                    echo "</select>\n";
                    echo "<a id=\"addtype\" href=\"javascript:void()\">New...</a>\n";
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
                if (count($oses) == 0) {
                    echo "Name <input type=\"text\" name=\"osname\" value=\"$osname\" />\n";
                    echo "Version <input type=\"text\" name=\"osversion\" value=\"$osversion\" />\n";
                } else {
                    echo "<select name=\"os\">\n";
                    foreach ($oses as $osid => $o) {
                        echo "<option" . ($os == $osid ? " selected=\"selected\"" : "") . " value=\"$osid\">$o</option>\n";
                    }
                    echo "</select>\n";
                    echo "<a id=\"addos\" href=\"javascript:void()\">New...</a>\n";
                }
                echo $oserror;
                ?>
            </td>
        </tr>
    </table>
    <div class="formsubmit">
        <input type="hidden" name="action" value="post" />
        <input type="submit" value="Add" />
    </div>
</form>

<?php include("include/footer.inc"); ?>

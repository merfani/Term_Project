<?php
function gettypes() {
    $result = mysql_query("SELECT type FROM types");
    
    $types = array();
    while ($row = mysql_fetch_assoc($result))
        $types[] = $row["type"];

    return $types;
}

function getoses() {
    $result = mysql_query("SELECT * FROM operating_systems");

    $oses = array();
    while ($row = mysql_fetch_assoc($result))
        $oses[$row["id"]] = $row["name"] . " " . $row["version"];

    return $oses;
}

function getos() {
    $result = mysql_query("SELECT name FROM operating_systems");

    $oses = array();
    while ($row = mysql_fetch_assoc($result))
        array_push($oses, $row["name"]);

    return $oses;
}

function getversion() {
    $result = mysql_query("SELECT version FROM operating_systems");

    $versions = array();
    while ($row = mysql_fetch_assoc($result))
        array_push($versions, $row["version"]);

    return $versions;
}



function getphysicalsystems() {
    $result = mysql_query("SELECT hostname FROM physical_systems");

    $physicalsystems = array();
    while ($row = mysql_fetch_assoc($result))
        $physicalsystems[] = $row["hostname"];

    return $physicalsystems;    
}

function getmodels() {
    $result = mysql_query("SELECT * FROM models");

    $models = array();
    while ($row = mysql_fetch_assoc($result))
        $models[$row["id"]] = $row["make"] . " " . $row["model"];

    return $models;
}

function getdatacenters() {
    $result = mysql_query("SELECT name FROM datacenter");

    $datacenters = array();
    while ($row = mysql_fetch_assoc($result))
        $datacenters[] = $row["name"];

    return $datacenters;
}

function getcabinets($datacenter) {
    $query = sprintf("SELECT * FROM cabinets WHERE datacenter_name='%s'", mysql_real_escape_string($datacenter));
    $result = mysql_query($query);

    $cabinets = array();
    while ($row = mysql_fetch_assoc($result))
        $cabinets[$row["id"]] = $row["row"] . "-" . $row["column"];

    return $cabinets;
}

function getphysicalhtml($serialnumber = "", $serialnumbererror = "", $assettag = "", $assettagerror = "", $model = "", $modelmake = "", $modelmodel = "", $modelheight = 0, $modelerror = "", $datacenter = "", $datacentername = "", $datacenteraddress = "", $datacentererror = "", $cabinet = "", $cabinetrow = "", $cabinetcolumn = "", $cabineterror = "", $cabinetposition = 0, $cabinetpositionerror = "") {
    $html = "
        <tr class=\"systemdetails\">
            <td>Model</td>
            <td id=\"modeltd\">";


    $models = getmodels();

    if (count($models) == 0 || strlen($modelmake) != 0 || strlen($modelmodel) != 0) {
        $html .= "Make <input type=\"text\" size=\"10\" name=\"modelmake\" value=\"$modelmake\" />\n";
        $html .= "Model <input type=\"text\" size=\"10\" name=\"modelmodel\" value=\"$modelmodel\" />\n";
        $html .= "Height <input type=\"text\" size=\"2\" name=\"modelheight\" value=\"$modelheight\" />\n";
    } else {
        $html .= "<select name=\"model\">\n";
        foreach ($models as $modelid => $m)
            $html .= "<option" . ($model == $modelid ? " selected=\"selected\"" : "") . " value=\"$modelid\">$m</option>\n";
        $html .= "</select>\n";
        $html .= "<a id=\"addmodel\" href=\"javascript:void(0);\">New...</a>\n";
    }

    $html .= "
                $modelerror
            </td>

        </tr>

        <tr class=\"systemdetails\">
            <td>Serial Number</td>
            <td><input type=\"text\" name=\"serialnumber\" value=\"$serialnumber\"> $serialnumbererror</td>
        </tr>

        <tr class=\"systemdetails\">
            <td>Asset Tag</td>
            <td><input type=\"text\" name=\"assettag\" value=\"$assettag\"> $assettagerror</td>
        </tr>

        <tr class=\"systemdetails\">
            <td>Datacenter</td>
            <td id=\"datacentertd\">";

    $datacenters = getdatacenters();

    if (count($datacenters) == 0 || strlen($datacentername) != 0 || strlen($datacenteraddress) != 0) {
        $html .= "Name <input type=\"text\" size=\"10\" name=\"datacentername\" value=\"$datacentername\" >\n";
        $html .= "Address <input type=\"text\" size=\"20\" name=\"datacenteraddress\" value=\"$datacenteraddress\" >\n";
    } else {
        $html .= "<select id=\"datacenterselect\" name=\"datacenter\">\n";
        foreach ($datacenters as $d)
            $html .= "<option" . ($datacenter == $d ? " selected=\"selected\"" : "") . ">$d</option>\n";
        $html .= "</select>\n";
        $html .= "<a id=\"adddatacenter\" href=\"javascript:void(0);\">New...</a>\n";
    }

    $html .= "
                $datacentererror
            </td>
        </tr>

        <tr class=\"systemdetails\">
            <td>Cabinet</td>
            <td id=\"cabinettd\">";

    $html .= getcabinetshtml($datacenter, $cabinet, $cabinetrow, $cabinetcolumn, $cabineterror);

    $html .= "
            </td>
        </tr>

        <tr class=\"systemdetails\">
            <td>Cabinet Position</td>
            <td><input type=\"text\" size=\"2\" name=\"cabinetposition\" value=\"$cabinetposition\"> $cabinetpositionerror</td>
        </tr>";

    return $html;
}

function getvirtualhtml($host = "", $hosterror = "") {
    $html = "
        <tr class=\"systemdetails\">
            <td>Host</td>
            <td>
                <select name=\"host\">";

    foreach (getphysicalsystems() as $physicalsystem)
        $html .= "<option" . ($host == $physicalsystem ? " selected=\"selected\"" : "") . ">$physicalsystem</option>";

    $html .= "
                </select>
                $hosterror
            </td>
        </tr>";

    return $html;
}

function getcabinetshtml($datacenter, $cabinet = "", $cabinetrow = "", $cabinetcolumn = "", $cabineterror = "") {
    $html = "";

    $cabinets = getcabinets($datacenter);

    if (count($cabinets) == 0 || strlen($cabinetrow) != 0 || strlen($cabinetcolumn) != 0) {
        $html .= "Row <input type=\"text\" size=\"2\" name=\"cabinetrow\" value=\"$cabinetrow\" >\n";
        $html .= "Column <input type=\"text\" size=\"2\" name=\"cabinetcolumn\" value=\"$cabinetcolumn\" >\n";
    } else {
        $html .= "<select name=\"cabinet\">\n";
        foreach ($cabinets as $cabinetid => $c)
            $html .= "<option" . ($cabinet == $cabinetid ? " selected=\"selected\"" : "") . " value=\"$cabinetid\">$c</option>\n";
        $html .= "</select>\n";
        $html .= "<a id=\"addcabinet\" href=\"javascript:void(0);\">New...</a>\n";
    }

    $html .= "$cabineterror\n";

    return $html;
}
?>

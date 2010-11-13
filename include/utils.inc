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

function getphysicalhtml($serialnumber = "", $serialnumbererror = "") {
    $html = "
        <tr class=\"systemdetails\">
            <td>Serial Number</td>
            <td><input type=\"text\" name=\"serialnumber\" value=\"$serialnumber\"> $serialnumbererror</td>
        </tr>";

    return $html;
}

function getvirtualhtml($host = "") {
    $html = "
        <tr class=\"systemdetails\">
            <td>Host</td>
            <td>
                <select name=\"host\">";

    foreach (getphysicalsystems() as $physicalsystem)
        $html .= "<option" . ($host == $physicalsystem ? " selected=\"selected\"" : "") . ">$physicalsystem</option>";

    $html .= "
                </select>
            </td>
        </tr>";

    return $html;
}
?>

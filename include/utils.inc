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
    $rows = mysql_num_rows($result);

    $oses = array();
    while ($row = mysql_fetch_assoc($result))
        $oses[$row["id"]] = $row["name"] . " " . $row["version"];

    return $oses;
}
?>

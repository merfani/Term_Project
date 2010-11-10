<?php
include("include/connectdb.inc");
include("include/utils.inc");

if ($_REQUEST["type"] == "physical")
    echo getphysicalhtml();
else if ($_REQUEST["type"] == "virtual")
    echo getvirtualhtml();
?>

<?php
include("../include/connectdb.inc");
include("../include/utils.inc");

echo getcabinetshtml($_REQUEST["datacenter"]);
?>

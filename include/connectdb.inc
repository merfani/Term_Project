<?php
mysql_connect("localhost", "inventory", "") or die("Could not connect: " . mysql_error());
mysql_select_db("inventory") or die("Could not select database.");
?>

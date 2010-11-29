<?php echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?" . ">\n"; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title><?php echo $title; ?></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link href="include/master.css" rel="stylesheet" type="text/css" />
        <script src="http://code.jquery.com/jquery-1.4.3.min.js" type="text/javascript"></script>
        <script src="include/master.js" type="text/javascript"></script>
        <?php
        if (isset($stylesheet)) echo "<link href=\"$stylesheet\" rel=\"stylesheet\" type=\"text/css\" />\n";
        if (isset($javascript)) echo "<script src=\"$javascript\" type=\"text/javascript\"></script>\n";
        ?>
    </head>

    <body>
        <div id="container">
<!--            <div id="logo">System Inventory</div><br />-->
            <span id="menu">
                <a href="addsystem.php">Add System</a><br />
                <a href= "browsesystem.php">Browse Systems</a><br> 
                <a href= "searchMain.html">Search Systems</a><br>
				
          </span>
  
            <div id="content">

drop database IF EXISTS  inventory;
create database IF NOT EXISTS inventory;
/*
Database              mysql 5_0
Project Name        Asset Manager
Project Version      Branch trunk - Version 6
Version Date         2010-11-01 21:05 GMT
Generated on        2010-11-01 21:05 GMT
*/

/*
The simplest way to execute this script is to run "mysql --verbose --show-warnings -p < /PATH/FILENAME"
See http://dev.mysql.com/doc/refman/5.0/en/invoking-programs.html for more detailed options.
*/

/*
Uncomment the below USE command if the default schema already exists in your database. 
*/

-- USE `inventory`;

/*
This section drops existing database objects before re-creating them, if so configured under the Options tab in SchemaBank. 
Note that dropping a database object (e.g. table) will remove all its data as well. Make sure you have a full backup of the database in case there is any problem that requires a recovery.
See http://dev.mysql.com/doc/refman/5.0/en/backup-and-recovery.html for reference.
*/

SET FOREIGN_KEY_CHECKS = 0;

SET FOREIGN_KEY_CHECKS = 1;

/*
This section creates the database objects defined in your project. If any of the objects already exists in the database, the mysql client program may raise an error and stop running the rest of the script.
*/

/*Schema inventory*/
CREATE SCHEMA IF NOT EXISTS `inventory`
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `inventory`;

CREATE TABLE `inventory`.`systems` (
`hostname` VARCHAR(20) NOT NULL,
`description` VARCHAR(20),
`type` VARCHAR(20) NOT NULL,
`os_id` INT NOT NULL,
PRIMARY KEY (`hostname`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`physical_systems` (
`hostname` VARCHAR(20) NOT NULL,
`serial_number` VARCHAR(20),
`cabinet_id` INT NOT NULL,
`cabinet_position` INT,
`model_id` INT NOT NULL,
`asset_tag` VARCHAR(20),
PRIMARY KEY (`hostname`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`virtual_systems` (
`hostname` VARCHAR(20) NOT NULL,
`physical_system_hostname` VARCHAR(20) NOT NULL,
PRIMARY KEY (`hostname`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`types` (
`type` VARCHAR(20) NOT NULL,
PRIMARY KEY (`type`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`projects` (
`name` VARCHAR(20) NOT NULL,
`customer_name` VARCHAR(20) NOT NULL,
PRIMARY KEY (`name`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`systems_projects` (
`hostname` VARCHAR(20) NOT NULL,
`project_name` VARCHAR(20) NOT NULL,
PRIMARY KEY (`hostname`,`project_name`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`customers` (
`name` VARCHAR(20) NOT NULL,
`contact_email` VARCHAR(20),
PRIMARY KEY (`name`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`administrators` (
`username` VARCHAR(20) NOT NULL,
`name` VARCHAR(20),
PRIMARY KEY (`username`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`administrators_projects` (
`administrator_username` VARCHAR(20) NOT NULL,
`project_name` VARCHAR(20) NOT NULL,
`role` VARCHAR(20),
PRIMARY KEY (`administrator_username`,`project_name`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`datacenter` (
`name` VARCHAR(20) NOT NULL,
`address` VARCHAR(20),
PRIMARY KEY (`name`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`cabinets` (
`id` INT NOT NULL AUTO_INCREMENT,
`row` VARCHAR(20) NOT NULL,
`column` VARCHAR(20) NOT NULL,
`datacenter_name` VARCHAR(20) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`models` (
`id` INT NOT NULL AUTO_INCREMENT,
`make` VARCHAR(20) NOT NULL,
`model` VARCHAR(20) NOT NULL,
`height` INT NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`operating_systems` (
`id` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL,
`version` VARCHAR(20) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`network_addresses` (
`ip_address` VARCHAR(20) NOT NULL,
`fqdn` VARCHAR(20),
`interface` VARCHAR(20) COMMENT 'Such as production, backup, lights out management interface.',
`system_hostname` VARCHAR(20) NOT NULL,
PRIMARY KEY (`ip_address`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

CREATE TABLE `inventory`.`comments` (
`id` INT NOT NULL AUTO_INCREMENT,
`date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
`comment` MEDIUMTEXT NOT NULL,
`hostname` VARCHAR(20) NOT NULL,
`admin` VARCHAR(20) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=INNODB
ROW_FORMAT=DEFAULT;

ALTER TABLE `inventory`.`cabinets` ADD UNIQUE `unique_row_column_datacenter` (`row`,`column`,`datacenter_name`);

ALTER TABLE `inventory`.`systems` ADD CONSTRAINT `fk_systemRelationship11` FOREIGN KEY (`type`) REFERENCES `inventory`.`types`(`type`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`systems` ADD CONSTRAINT `fk_systemsRelationship26` FOREIGN KEY (`os_id`) REFERENCES `inventory`.`operating_systems`(`id`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`physical_systems` ADD CONSTRAINT `fk_Physical SystemRelationship6` FOREIGN KEY (`hostname`) REFERENCES `inventory`.`systems`(`hostname`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`physical_systems` ADD CONSTRAINT `fk_physical_systemsRelationship24` FOREIGN KEY (`cabinet_id`) REFERENCES `inventory`.`cabinets`(`id`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`physical_systems` ADD CONSTRAINT `fk_physical_systemsRelationship25` FOREIGN KEY (`model_id`) REFERENCES `inventory`.`models`(`id`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`virtual_systems` ADD CONSTRAINT `fk_Virtual SystemRelationship8` FOREIGN KEY (`hostname`) REFERENCES `inventory`.`systems`(`hostname`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`virtual_systems` ADD CONSTRAINT `fk_virtual_systemRelationship12` FOREIGN KEY (`physical_system_hostname`) REFERENCES `inventory`.`physical_systems`(`hostname`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`projects` ADD CONSTRAINT `fk_projectRelationship18` FOREIGN KEY (`customer_name`) REFERENCES `inventory`.`customers`(`name`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`systems_projects` ADD CONSTRAINT `fk_system_projectsRelationship15` FOREIGN KEY (`hostname`) REFERENCES `inventory`.`systems`(`hostname`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`systems_projects` ADD CONSTRAINT `fk_system_projectsRelationship16` FOREIGN KEY (`project_name`) REFERENCES `inventory`.`projects`(`name`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`administrators_projects` ADD CONSTRAINT `fk_administrators_projectsRelationship20` FOREIGN KEY (`administrator_username`) REFERENCES `inventory`.`administrators`(`username`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`administrators_projects` ADD CONSTRAINT `fk_administrators_projectsRelationship21` FOREIGN KEY (`project_name`) REFERENCES `inventory`.`projects`(`name`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`cabinets` ADD CONSTRAINT `fk_cabinetRelationship23` FOREIGN KEY (`datacenter_name`) REFERENCES `inventory`.`datacenter`(`name`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`network_addresses` ADD CONSTRAINT `fk_network_addressesRelationship27` FOREIGN KEY (`system_hostname`) REFERENCES `inventory`.`systems`(`hostname`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`comments` ADD CONSTRAINT `fk_commentsRelationship28` FOREIGN KEY (`hostname`) REFERENCES `inventory`.`systems`(`hostname`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE `inventory`.`comments` ADD CONSTRAINT `fk_commentsRelationship29` FOREIGN KEY (`admin`) REFERENCES `inventory`.`administrators`(`username`) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;
insert into operating_systems VALUES("","os_name_1", "version_1");
insert into types VALUES("type_1");
insert into systems VALUES("hostname_1", "descript_1", "type_1", "1");
insert into operating_systems VALUES("","os_name_2", "version_2");
insert into types VALUES("type_2");
insert into systems VALUES("hostname_2", "descript_2", "type_2", "2");
insert into operating_systems VALUES("","os_name_3", "version_3");
insert into types VALUES("type_3");
insert into systems VALUES("hostname_3", "descript_3", "type_3", "3");
insert into operating_systems VALUES("","os_name_4", "version_4");
insert into types VALUES("type_4");
insert into systems VALUES("hostname_4", "descript_4", "type_4", "4");
insert into types VALUES("type1");
insert into systems VALUES("BHost1", "descript", "type1", "1");
insert into types VALUES("type2");
insert into systems VALUES("BHost2", "descript", "type2", "1");
insert into types VALUES("type3");
insert into systems VALUES("BHost3", "descript", "type3", "1");
insert into types VALUES("type4");
insert into systems VALUES("BHost4", "descript", "type4", "1");
insert into types VALUES("type5");
insert into systems VALUES("BHost5", "descript", "type5", "1");
insert into types VALUES("type6");
insert into systems VALUES("BHost6", "descript", "type6", "1");
insert into types VALUES("type7");
insert into systems VALUES("BHost7", "descript", "type7", "1");
insert into types VALUES("type8");
insert into systems VALUES("BHost8", "descript", "type8", "1");
insert into types VALUES("type9");
insert into systems VALUES("BHost9", "descript", "type9", "1");
insert into types VALUES("type10");
insert into systems VALUES("BHost10", "descript", "type10", "1");
insert into types VALUES("type11");
insert into systems VALUES("BHost11", "descript", "type11", "1");
insert into types VALUES("type12");
insert into systems VALUES("BHost12", "descript", "type12", "1");
insert into types VALUES("type13");
insert into systems VALUES("BHost13", "descript", "type13", "1");
insert into types VALUES("type14");
insert into systems VALUES("BHost14", "descript", "type14", "1");
insert into types VALUES("type15");
insert into systems VALUES("BHost15", "descript", "type15", "1");
insert into types VALUES("type16");
insert into systems VALUES("BHost16", "descript", "type16", "1");
insert into types VALUES("type17");
insert into systems VALUES("BHost17", "descript", "type17", "1");
insert into types VALUES("type18");
insert into systems VALUES("BHost18", "descript", "type18", "1");
insert into types VALUES("type19");
insert into systems VALUES("BHost19", "descript", "type19", "1");
insert into types VALUES("type20");
insert into systems VALUES("BHost20", "descript", "type20", "1");
insert into types VALUES("type21");
insert into systems VALUES("BHost21", "descript", "type21", "1");
insert into types VALUES("type22");
insert into systems VALUES("BHost22", "descript", "type22", "1");
insert into types VALUES("type23");
insert into systems VALUES("BHost23", "descript", "type23", "1");
insert into types VALUES("type24");
insert into systems VALUES("BHost24", "descript", "type24", "1");
insert into types VALUES("type25");
insert into systems VALUES("BHost25", "descript", "type25", "1");
insert into types VALUES("type26");
insert into systems VALUES("BHost26", "descript", "type26", "1");
insert into types VALUES("type27");
insert into systems VALUES("BHost27", "descript", "type27", "1");
insert into types VALUES("type28");
insert into systems VALUES("BHost28", "descript", "type28", "1");
insert into types VALUES("type29");
insert into systems VALUES("BHost29", "descript", "type29", "1");
insert into types VALUES("type30");
insert into systems VALUES("BHost30", "descript", "type30", "1");
insert into types VALUES("type31");
insert into systems VALUES("BHost31", "descript", "type31", "1");
insert into types VALUES("type32");
insert into systems VALUES("BHost32", "descript", "type32", "1");
insert into types VALUES("type33");
insert into systems VALUES("BHost33", "descript", "type33", "1");
insert into types VALUES("type34");
insert into systems VALUES("BHost34", "descript", "type34", "1");
insert into types VALUES("type35");
insert into systems VALUES("BHost35", "descript", "type35", "1");
insert into types VALUES("type36");
insert into systems VALUES("BHost36", "descript", "type36", "1");
insert into types VALUES("type37");
insert into systems VALUES("BHost37", "descript", "type37", "1");
insert into types VALUES("type38");
insert into systems VALUES("BHost38", "descript", "type38", "1");
insert into types VALUES("type39");
insert into systems VALUES("BHost39", "descript", "type39", "1");
insert into types VALUES("type40");
insert into systems VALUES("BHost40", "descript", "type40", "1");
insert into types VALUES("type41");
insert into systems VALUES("BHost41", "descript", "type41", "1");
insert into types VALUES("type42");
insert into systems VALUES("BHost42", "descript", "type42", "1");
insert into types VALUES("type43");
insert into systems VALUES("BHost43", "descript", "type43", "1");
insert into types VALUES("type44");
insert into systems VALUES("BHost44", "descript", "type44", "1");
insert into types VALUES("type45");
insert into systems VALUES("BHost45", "descript", "type45", "1");
insert into types VALUES("type46");
insert into systems VALUES("BHost46", "descript", "type46", "1");
insert into types VALUES("type47");
insert into systems VALUES("BHost47", "descript", "type47", "1");
insert into types VALUES("type48");
insert into systems VALUES("BHost48", "descript", "type48", "1");
insert into types VALUES("type49");
insert into systems VALUES("BHost49", "descript", "type49", "1");
insert into datacenter VALUES("datacenter1", "dc_address1");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row1", "rack_column1", "datacenter1" );
insert into customers VALUES("customer_name1", "cust@email1.com");
insert into projects VALUES("project_name1", "customer_name1");
insert into administrators VALUES("username1", "name1");
insert into administrators_projects VALUES("username1", "project_name1", "role1");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment1", "BHost1", "username1");
insert into models (`make`, `model`, `height`) VALUES("make1", "model1", "1");
insert into network_addresses VALUES("ip_address1", "fqdn1", "interface1", "BHost1");
insert into operating_systems (`name`, `version`) VALUES("OS_name1", "version1");
insert into physical_systems VALUES("BHost1", "serial1", "1", "1", "1", "assetTag1");
insert into systems_projects VALUES("BHost1", "project_name1");
insert into datacenter VALUES("datacenter2", "dc_address2");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row2", "rack_column2", "datacenter2" );
insert into customers VALUES("customer_name2", "cust@email2.com");
insert into projects VALUES("project_name2", "customer_name2");
insert into administrators VALUES("username2", "name2");
insert into administrators_projects VALUES("username2", "project_name2", "role2");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment2", "BHost2", "username2");
insert into models (`make`, `model`, `height`) VALUES("make2", "model2", "2");
insert into network_addresses VALUES("ip_address2", "fqdn2", "interface2", "BHost2");
insert into operating_systems (`name`, `version`) VALUES("OS_name2", "version2");
insert into physical_systems VALUES("BHost2", "serial2", "2", "2", "2", "assetTag2");
insert into systems_projects VALUES("BHost2", "project_name2");
insert into datacenter VALUES("datacenter3", "dc_address3");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row3", "rack_column3", "datacenter3" );
insert into customers VALUES("customer_name3", "cust@email3.com");
insert into projects VALUES("project_name3", "customer_name3");
insert into administrators VALUES("username3", "name3");
insert into administrators_projects VALUES("username3", "project_name3", "role3");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment3", "BHost3", "username3");
insert into models (`make`, `model`, `height`) VALUES("make3", "model3", "3");
insert into network_addresses VALUES("ip_address3", "fqdn3", "interface3", "BHost3");
insert into operating_systems (`name`, `version`) VALUES("OS_name3", "version3");
insert into physical_systems VALUES("BHost3", "serial3", "3", "3", "3", "assetTag3");
insert into systems_projects VALUES("BHost3", "project_name3");
insert into datacenter VALUES("datacenter4", "dc_address4");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row4", "rack_column4", "datacenter4" );
insert into customers VALUES("customer_name4", "cust@email4.com");
insert into projects VALUES("project_name4", "customer_name4");
insert into administrators VALUES("username4", "name4");
insert into administrators_projects VALUES("username4", "project_name4", "role4");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment4", "BHost4", "username4");
insert into models (`make`, `model`, `height`) VALUES("make4", "model4", "4");
insert into network_addresses VALUES("ip_address4", "fqdn4", "interface4", "BHost4");
insert into operating_systems (`name`, `version`) VALUES("OS_name4", "version4");
insert into physical_systems VALUES("BHost4", "serial4", "4", "4", "4", "assetTag4");
insert into systems_projects VALUES("BHost4", "project_name4");
insert into datacenter VALUES("datacenter5", "dc_address5");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row5", "rack_column5", "datacenter5" );
insert into customers VALUES("customer_name5", "cust@email5.com");
insert into projects VALUES("project_name5", "customer_name5");
insert into administrators VALUES("username5", "name5");
insert into administrators_projects VALUES("username5", "project_name5", "role5");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment5", "BHost5", "username5");
insert into models (`make`, `model`, `height`) VALUES("make5", "model5", "5");
insert into network_addresses VALUES("ip_address5", "fqdn5", "interface5", "BHost5");
insert into operating_systems (`name`, `version`) VALUES("OS_name5", "version5");
insert into physical_systems VALUES("BHost5", "serial5", "5", "5", "5", "assetTag5");
insert into systems_projects VALUES("BHost5", "project_name5");
insert into datacenter VALUES("datacenter6", "dc_address6");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row6", "rack_column6", "datacenter6" );
insert into customers VALUES("customer_name6", "cust@email6.com");
insert into projects VALUES("project_name6", "customer_name6");
insert into administrators VALUES("username6", "name6");
insert into administrators_projects VALUES("username6", "project_name6", "role6");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment6", "BHost6", "username6");
insert into models (`make`, `model`, `height`) VALUES("make6", "model6", "6");
insert into network_addresses VALUES("ip_address6", "fqdn6", "interface6", "BHost6");
insert into operating_systems (`name`, `version`) VALUES("OS_name6", "version6");
insert into physical_systems VALUES("BHost6", "serial6", "6", "6", "6", "assetTag6");
insert into systems_projects VALUES("BHost6", "project_name6");
insert into datacenter VALUES("datacenter7", "dc_address7");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row7", "rack_column7", "datacenter7" );
insert into customers VALUES("customer_name7", "cust@email7.com");
insert into projects VALUES("project_name7", "customer_name7");
insert into administrators VALUES("username7", "name7");
insert into administrators_projects VALUES("username7", "project_name7", "role7");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment7", "BHost7", "username7");
insert into models (`make`, `model`, `height`) VALUES("make7", "model7", "7");
insert into network_addresses VALUES("ip_address7", "fqdn7", "interface7", "BHost7");
insert into operating_systems (`name`, `version`) VALUES("OS_name7", "version7");
insert into physical_systems VALUES("BHost7", "serial7", "7", "7", "7", "assetTag7");
insert into systems_projects VALUES("BHost7", "project_name7");
insert into datacenter VALUES("datacenter8", "dc_address8");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row8", "rack_column8", "datacenter8" );
insert into customers VALUES("customer_name8", "cust@email8.com");
insert into projects VALUES("project_name8", "customer_name8");
insert into administrators VALUES("username8", "name8");
insert into administrators_projects VALUES("username8", "project_name8", "role8");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment8", "BHost8", "username8");
insert into models (`make`, `model`, `height`) VALUES("make8", "model8", "8");
insert into network_addresses VALUES("ip_address8", "fqdn8", "interface8", "BHost8");
insert into operating_systems (`name`, `version`) VALUES("OS_name8", "version8");
insert into physical_systems VALUES("BHost8", "serial8", "8", "8", "8", "assetTag8");
insert into systems_projects VALUES("BHost8", "project_name8");
insert into datacenter VALUES("datacenter9", "dc_address9");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row9", "rack_column9", "datacenter9" );
insert into customers VALUES("customer_name9", "cust@email9.com");
insert into projects VALUES("project_name9", "customer_name9");
insert into administrators VALUES("username9", "name9");
insert into administrators_projects VALUES("username9", "project_name9", "role9");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment9", "BHost9", "username9");
insert into models (`make`, `model`, `height`) VALUES("make9", "model9", "9");
insert into network_addresses VALUES("ip_address9", "fqdn9", "interface9", "BHost9");
insert into operating_systems (`name`, `version`) VALUES("OS_name9", "version9");
insert into physical_systems VALUES("BHost9", "serial9", "9", "9", "9", "assetTag9");
insert into systems_projects VALUES("BHost9", "project_name9");
insert into datacenter VALUES("datacenter10", "dc_address10");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row10", "rack_column10", "datacenter10" );
insert into customers VALUES("customer_name10", "cust@email10.com");
insert into projects VALUES("project_name10", "customer_name10");
insert into administrators VALUES("username10", "name10");
insert into administrators_projects VALUES("username10", "project_name10", "role10");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment10", "BHost10", "username10");
insert into models (`make`, `model`, `height`) VALUES("make10", "model10", "10");
insert into network_addresses VALUES("ip_address10", "fqdn10", "interface10", "BHost10");
insert into operating_systems (`name`, `version`) VALUES("OS_name10", "version10");
insert into physical_systems VALUES("BHost10", "serial10", "10", "10", "10", "assetTag10");
insert into systems_projects VALUES("BHost10", "project_name10");
insert into datacenter VALUES("datacenter11", "dc_address11");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row11", "rack_column11", "datacenter11" );
insert into customers VALUES("customer_name11", "cust@email11.com");
insert into projects VALUES("project_name11", "customer_name11");
insert into administrators VALUES("username11", "name11");
insert into administrators_projects VALUES("username11", "project_name11", "role11");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment11", "BHost11", "username11");
insert into models (`make`, `model`, `height`) VALUES("make11", "model11", "11");
insert into network_addresses VALUES("ip_address11", "fqdn11", "interface11", "BHost11");
insert into operating_systems (`name`, `version`) VALUES("OS_name11", "version11");
insert into physical_systems VALUES("BHost11", "serial11", "11", "11", "11", "assetTag11");
insert into systems_projects VALUES("BHost11", "project_name11");
insert into datacenter VALUES("datacenter12", "dc_address12");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row12", "rack_column12", "datacenter12" );
insert into customers VALUES("customer_name12", "cust@email12.com");
insert into projects VALUES("project_name12", "customer_name12");
insert into administrators VALUES("username12", "name12");
insert into administrators_projects VALUES("username12", "project_name12", "role12");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment12", "BHost12", "username12");
insert into models (`make`, `model`, `height`) VALUES("make12", "model12", "12");
insert into network_addresses VALUES("ip_address12", "fqdn12", "interface12", "BHost12");
insert into operating_systems (`name`, `version`) VALUES("OS_name12", "version12");
insert into physical_systems VALUES("BHost12", "serial12", "12", "12", "12", "assetTag12");
insert into systems_projects VALUES("BHost12", "project_name12");
insert into datacenter VALUES("datacenter13", "dc_address13");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row13", "rack_column13", "datacenter13" );
insert into customers VALUES("customer_name13", "cust@email13.com");
insert into projects VALUES("project_name13", "customer_name13");
insert into administrators VALUES("username13", "name13");
insert into administrators_projects VALUES("username13", "project_name13", "role13");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment13", "BHost13", "username13");
insert into models (`make`, `model`, `height`) VALUES("make13", "model13", "13");
insert into network_addresses VALUES("ip_address13", "fqdn13", "interface13", "BHost13");
insert into operating_systems (`name`, `version`) VALUES("OS_name13", "version13");
insert into physical_systems VALUES("BHost13", "serial13", "13", "13", "13", "assetTag13");
insert into systems_projects VALUES("BHost13", "project_name13");
insert into datacenter VALUES("datacenter14", "dc_address14");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row14", "rack_column14", "datacenter14" );
insert into customers VALUES("customer_name14", "cust@email14.com");
insert into projects VALUES("project_name14", "customer_name14");
insert into administrators VALUES("username14", "name14");
insert into administrators_projects VALUES("username14", "project_name14", "role14");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment14", "BHost14", "username14");
insert into models (`make`, `model`, `height`) VALUES("make14", "model14", "14");
insert into network_addresses VALUES("ip_address14", "fqdn14", "interface14", "BHost14");
insert into operating_systems (`name`, `version`) VALUES("OS_name14", "version14");
insert into physical_systems VALUES("BHost14", "serial14", "14", "14", "14", "assetTag14");
insert into systems_projects VALUES("BHost14", "project_name14");
insert into datacenter VALUES("datacenter15", "dc_address15");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row15", "rack_column15", "datacenter15" );
insert into customers VALUES("customer_name15", "cust@email15.com");
insert into projects VALUES("project_name15", "customer_name15");
insert into administrators VALUES("username15", "name15");
insert into administrators_projects VALUES("username15", "project_name15", "role15");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment15", "BHost15", "username15");
insert into models (`make`, `model`, `height`) VALUES("make15", "model15", "15");
insert into network_addresses VALUES("ip_address15", "fqdn15", "interface15", "BHost15");
insert into operating_systems (`name`, `version`) VALUES("OS_name15", "version15");
insert into physical_systems VALUES("BHost15", "serial15", "15", "15", "15", "assetTag15");
insert into systems_projects VALUES("BHost15", "project_name15");
insert into datacenter VALUES("datacenter16", "dc_address16");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row16", "rack_column16", "datacenter16" );
insert into customers VALUES("customer_name16", "cust@email16.com");
insert into projects VALUES("project_name16", "customer_name16");
insert into administrators VALUES("username16", "name16");
insert into administrators_projects VALUES("username16", "project_name16", "role16");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment16", "BHost16", "username16");
insert into models (`make`, `model`, `height`) VALUES("make16", "model16", "16");
insert into network_addresses VALUES("ip_address16", "fqdn16", "interface16", "BHost16");
insert into operating_systems (`name`, `version`) VALUES("OS_name16", "version16");
insert into physical_systems VALUES("BHost16", "serial16", "16", "16", "16", "assetTag16");
insert into systems_projects VALUES("BHost16", "project_name16");
insert into datacenter VALUES("datacenter17", "dc_address17");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row17", "rack_column17", "datacenter17" );
insert into customers VALUES("customer_name17", "cust@email17.com");
insert into projects VALUES("project_name17", "customer_name17");
insert into administrators VALUES("username17", "name17");
insert into administrators_projects VALUES("username17", "project_name17", "role17");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment17", "BHost17", "username17");
insert into models (`make`, `model`, `height`) VALUES("make17", "model17", "17");
insert into network_addresses VALUES("ip_address17", "fqdn17", "interface17", "BHost17");
insert into operating_systems (`name`, `version`) VALUES("OS_name17", "version17");
insert into physical_systems VALUES("BHost17", "serial17", "17", "17", "17", "assetTag17");
insert into systems_projects VALUES("BHost17", "project_name17");
insert into datacenter VALUES("datacenter18", "dc_address18");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row18", "rack_column18", "datacenter18" );
insert into customers VALUES("customer_name18", "cust@email18.com");
insert into projects VALUES("project_name18", "customer_name18");
insert into administrators VALUES("username18", "name18");
insert into administrators_projects VALUES("username18", "project_name18", "role18");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment18", "BHost18", "username18");
insert into models (`make`, `model`, `height`) VALUES("make18", "model18", "18");
insert into network_addresses VALUES("ip_address18", "fqdn18", "interface18", "BHost18");
insert into operating_systems (`name`, `version`) VALUES("OS_name18", "version18");
insert into physical_systems VALUES("BHost18", "serial18", "18", "18", "18", "assetTag18");
insert into systems_projects VALUES("BHost18", "project_name18");
insert into datacenter VALUES("datacenter19", "dc_address19");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row19", "rack_column19", "datacenter19" );
insert into customers VALUES("customer_name19", "cust@email19.com");
insert into projects VALUES("project_name19", "customer_name19");
insert into administrators VALUES("username19", "name19");
insert into administrators_projects VALUES("username19", "project_name19", "role19");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment19", "BHost19", "username19");
insert into models (`make`, `model`, `height`) VALUES("make19", "model19", "19");
insert into network_addresses VALUES("ip_address19", "fqdn19", "interface19", "BHost19");
insert into operating_systems (`name`, `version`) VALUES("OS_name19", "version19");
insert into physical_systems VALUES("BHost19", "serial19", "19", "19", "19", "assetTag19");
insert into systems_projects VALUES("BHost19", "project_name19");
insert into datacenter VALUES("datacenter20", "dc_address20");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row20", "rack_column20", "datacenter20" );
insert into customers VALUES("customer_name20", "cust@email20.com");
insert into projects VALUES("project_name20", "customer_name20");
insert into administrators VALUES("username20", "name20");
insert into administrators_projects VALUES("username20", "project_name20", "role20");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment20", "BHost20", "username20");
insert into models (`make`, `model`, `height`) VALUES("make20", "model20", "20");
insert into network_addresses VALUES("ip_address20", "fqdn20", "interface20", "BHost20");
insert into operating_systems (`name`, `version`) VALUES("OS_name20", "version20");
insert into physical_systems VALUES("BHost20", "serial20", "20", "20", "20", "assetTag20");
insert into systems_projects VALUES("BHost20", "project_name20");
insert into datacenter VALUES("datacenter21", "dc_address21");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row21", "rack_column21", "datacenter21" );
insert into customers VALUES("customer_name21", "cust@email21.com");
insert into projects VALUES("project_name21", "customer_name21");
insert into administrators VALUES("username21", "name21");
insert into administrators_projects VALUES("username21", "project_name21", "role21");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment21", "BHost21", "username21");
insert into models (`make`, `model`, `height`) VALUES("make21", "model21", "21");
insert into network_addresses VALUES("ip_address21", "fqdn21", "interface21", "BHost21");
insert into operating_systems (`name`, `version`) VALUES("OS_name21", "version21");
insert into physical_systems VALUES("BHost21", "serial21", "21", "21", "21", "assetTag21");
insert into systems_projects VALUES("BHost21", "project_name21");
insert into datacenter VALUES("datacenter22", "dc_address22");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row22", "rack_column22", "datacenter22" );
insert into customers VALUES("customer_name22", "cust@email22.com");
insert into projects VALUES("project_name22", "customer_name22");
insert into administrators VALUES("username22", "name22");
insert into administrators_projects VALUES("username22", "project_name22", "role22");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment22", "BHost22", "username22");
insert into models (`make`, `model`, `height`) VALUES("make22", "model22", "22");
insert into network_addresses VALUES("ip_address22", "fqdn22", "interface22", "BHost22");
insert into operating_systems (`name`, `version`) VALUES("OS_name22", "version22");
insert into physical_systems VALUES("BHost22", "serial22", "22", "22", "22", "assetTag22");
insert into systems_projects VALUES("BHost22", "project_name22");
insert into datacenter VALUES("datacenter23", "dc_address23");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row23", "rack_column23", "datacenter23" );
insert into customers VALUES("customer_name23", "cust@email23.com");
insert into projects VALUES("project_name23", "customer_name23");
insert into administrators VALUES("username23", "name23");
insert into administrators_projects VALUES("username23", "project_name23", "role23");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment23", "BHost23", "username23");
insert into models (`make`, `model`, `height`) VALUES("make23", "model23", "23");
insert into network_addresses VALUES("ip_address23", "fqdn23", "interface23", "BHost23");
insert into operating_systems (`name`, `version`) VALUES("OS_name23", "version23");
insert into physical_systems VALUES("BHost23", "serial23", "23", "23", "23", "assetTag23");
insert into systems_projects VALUES("BHost23", "project_name23");
insert into datacenter VALUES("datacenter24", "dc_address24");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row24", "rack_column24", "datacenter24" );
insert into customers VALUES("customer_name24", "cust@email24.com");
insert into projects VALUES("project_name24", "customer_name24");
insert into administrators VALUES("username24", "name24");
insert into administrators_projects VALUES("username24", "project_name24", "role24");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment24", "BHost24", "username24");
insert into models (`make`, `model`, `height`) VALUES("make24", "model24", "24");
insert into network_addresses VALUES("ip_address24", "fqdn24", "interface24", "BHost24");
insert into operating_systems (`name`, `version`) VALUES("OS_name24", "version24");
insert into physical_systems VALUES("BHost24", "serial24", "24", "24", "24", "assetTag24");
insert into systems_projects VALUES("BHost24", "project_name24");
insert into datacenter VALUES("datacenter25", "dc_address25");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row25", "rack_column25", "datacenter25" );
insert into customers VALUES("customer_name25", "cust@email25.com");
insert into projects VALUES("project_name25", "customer_name25");
insert into administrators VALUES("username25", "name25");
insert into administrators_projects VALUES("username25", "project_name25", "role25");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment25", "BHost25", "username25");
insert into models (`make`, `model`, `height`) VALUES("make25", "model25", "25");
insert into network_addresses VALUES("ip_address25", "fqdn25", "interface25", "BHost25");
insert into operating_systems (`name`, `version`) VALUES("OS_name25", "version25");
insert into physical_systems VALUES("BHost25", "serial25", "25", "25", "25", "assetTag25");
insert into systems_projects VALUES("BHost25", "project_name25");
insert into datacenter VALUES("datacenter26", "dc_address26");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row26", "rack_column26", "datacenter26" );
insert into customers VALUES("customer_name26", "cust@email26.com");
insert into projects VALUES("project_name26", "customer_name26");
insert into administrators VALUES("username26", "name26");
insert into administrators_projects VALUES("username26", "project_name26", "role26");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment26", "BHost26", "username26");
insert into models (`make`, `model`, `height`) VALUES("make26", "model26", "26");
insert into network_addresses VALUES("ip_address26", "fqdn26", "interface26", "BHost26");
insert into operating_systems (`name`, `version`) VALUES("OS_name26", "version26");
insert into physical_systems VALUES("BHost26", "serial26", "26", "26", "26", "assetTag26");
insert into systems_projects VALUES("BHost26", "project_name26");
insert into datacenter VALUES("datacenter27", "dc_address27");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row27", "rack_column27", "datacenter27" );
insert into customers VALUES("customer_name27", "cust@email27.com");
insert into projects VALUES("project_name27", "customer_name27");
insert into administrators VALUES("username27", "name27");
insert into administrators_projects VALUES("username27", "project_name27", "role27");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment27", "BHost27", "username27");
insert into models (`make`, `model`, `height`) VALUES("make27", "model27", "27");
insert into network_addresses VALUES("ip_address27", "fqdn27", "interface27", "BHost27");
insert into operating_systems (`name`, `version`) VALUES("OS_name27", "version27");
insert into physical_systems VALUES("BHost27", "serial27", "27", "27", "27", "assetTag27");
insert into systems_projects VALUES("BHost27", "project_name27");
insert into datacenter VALUES("datacenter28", "dc_address28");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row28", "rack_column28", "datacenter28" );
insert into customers VALUES("customer_name28", "cust@email28.com");
insert into projects VALUES("project_name28", "customer_name28");
insert into administrators VALUES("username28", "name28");
insert into administrators_projects VALUES("username28", "project_name28", "role28");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment28", "BHost28", "username28");
insert into models (`make`, `model`, `height`) VALUES("make28", "model28", "28");
insert into network_addresses VALUES("ip_address28", "fqdn28", "interface28", "BHost28");
insert into operating_systems (`name`, `version`) VALUES("OS_name28", "version28");
insert into physical_systems VALUES("BHost28", "serial28", "28", "28", "28", "assetTag28");
insert into systems_projects VALUES("BHost28", "project_name28");
insert into datacenter VALUES("datacenter29", "dc_address29");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row29", "rack_column29", "datacenter29" );
insert into customers VALUES("customer_name29", "cust@email29.com");
insert into projects VALUES("project_name29", "customer_name29");
insert into administrators VALUES("username29", "name29");
insert into administrators_projects VALUES("username29", "project_name29", "role29");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment29", "BHost29", "username29");
insert into models (`make`, `model`, `height`) VALUES("make29", "model29", "29");
insert into network_addresses VALUES("ip_address29", "fqdn29", "interface29", "BHost29");
insert into operating_systems (`name`, `version`) VALUES("OS_name29", "version29");
insert into physical_systems VALUES("BHost29", "serial29", "29", "29", "29", "assetTag29");
insert into systems_projects VALUES("BHost29", "project_name29");
insert into datacenter VALUES("datacenter30", "dc_address30");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row30", "rack_column30", "datacenter30" );
insert into customers VALUES("customer_name30", "cust@email30.com");
insert into projects VALUES("project_name30", "customer_name30");
insert into administrators VALUES("username30", "name30");
insert into administrators_projects VALUES("username30", "project_name30", "role30");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment30", "BHost30", "username30");
insert into models (`make`, `model`, `height`) VALUES("make30", "model30", "30");
insert into network_addresses VALUES("ip_address30", "fqdn30", "interface30", "BHost30");
insert into operating_systems (`name`, `version`) VALUES("OS_name30", "version30");
insert into physical_systems VALUES("BHost30", "serial30", "30", "30", "30", "assetTag30");
insert into systems_projects VALUES("BHost30", "project_name30");
insert into datacenter VALUES("datacenter31", "dc_address31");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row31", "rack_column31", "datacenter31" );
insert into customers VALUES("customer_name31", "cust@email31.com");
insert into projects VALUES("project_name31", "customer_name31");
insert into administrators VALUES("username31", "name31");
insert into administrators_projects VALUES("username31", "project_name31", "role31");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment31", "BHost31", "username31");
insert into models (`make`, `model`, `height`) VALUES("make31", "model31", "31");
insert into network_addresses VALUES("ip_address31", "fqdn31", "interface31", "BHost31");
insert into operating_systems (`name`, `version`) VALUES("OS_name31", "version31");
insert into physical_systems VALUES("BHost31", "serial31", "31", "31", "31", "assetTag31");
insert into systems_projects VALUES("BHost31", "project_name31");
insert into datacenter VALUES("datacenter32", "dc_address32");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row32", "rack_column32", "datacenter32" );
insert into customers VALUES("customer_name32", "cust@email32.com");
insert into projects VALUES("project_name32", "customer_name32");
insert into administrators VALUES("username32", "name32");
insert into administrators_projects VALUES("username32", "project_name32", "role32");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment32", "BHost32", "username32");
insert into models (`make`, `model`, `height`) VALUES("make32", "model32", "32");
insert into network_addresses VALUES("ip_address32", "fqdn32", "interface32", "BHost32");
insert into operating_systems (`name`, `version`) VALUES("OS_name32", "version32");
insert into physical_systems VALUES("BHost32", "serial32", "32", "32", "32", "assetTag32");
insert into systems_projects VALUES("BHost32", "project_name32");
insert into datacenter VALUES("datacenter33", "dc_address33");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row33", "rack_column33", "datacenter33" );
insert into customers VALUES("customer_name33", "cust@email33.com");
insert into projects VALUES("project_name33", "customer_name33");
insert into administrators VALUES("username33", "name33");
insert into administrators_projects VALUES("username33", "project_name33", "role33");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment33", "BHost33", "username33");
insert into models (`make`, `model`, `height`) VALUES("make33", "model33", "33");
insert into network_addresses VALUES("ip_address33", "fqdn33", "interface33", "BHost33");
insert into operating_systems (`name`, `version`) VALUES("OS_name33", "version33");
insert into physical_systems VALUES("BHost33", "serial33", "33", "33", "33", "assetTag33");
insert into systems_projects VALUES("BHost33", "project_name33");
insert into datacenter VALUES("datacenter34", "dc_address34");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row34", "rack_column34", "datacenter34" );
insert into customers VALUES("customer_name34", "cust@email34.com");
insert into projects VALUES("project_name34", "customer_name34");
insert into administrators VALUES("username34", "name34");
insert into administrators_projects VALUES("username34", "project_name34", "role34");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment34", "BHost34", "username34");
insert into models (`make`, `model`, `height`) VALUES("make34", "model34", "34");
insert into network_addresses VALUES("ip_address34", "fqdn34", "interface34", "BHost34");
insert into operating_systems (`name`, `version`) VALUES("OS_name34", "version34");
insert into physical_systems VALUES("BHost34", "serial34", "34", "34", "34", "assetTag34");
insert into systems_projects VALUES("BHost34", "project_name34");
insert into datacenter VALUES("datacenter35", "dc_address35");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row35", "rack_column35", "datacenter35" );
insert into customers VALUES("customer_name35", "cust@email35.com");
insert into projects VALUES("project_name35", "customer_name35");
insert into administrators VALUES("username35", "name35");
insert into administrators_projects VALUES("username35", "project_name35", "role35");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment35", "BHost35", "username35");
insert into models (`make`, `model`, `height`) VALUES("make35", "model35", "35");
insert into network_addresses VALUES("ip_address35", "fqdn35", "interface35", "BHost35");
insert into operating_systems (`name`, `version`) VALUES("OS_name35", "version35");
insert into physical_systems VALUES("BHost35", "serial35", "35", "35", "35", "assetTag35");
insert into systems_projects VALUES("BHost35", "project_name35");
insert into datacenter VALUES("datacenter36", "dc_address36");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row36", "rack_column36", "datacenter36" );
insert into customers VALUES("customer_name36", "cust@email36.com");
insert into projects VALUES("project_name36", "customer_name36");
insert into administrators VALUES("username36", "name36");
insert into administrators_projects VALUES("username36", "project_name36", "role36");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment36", "BHost36", "username36");
insert into models (`make`, `model`, `height`) VALUES("make36", "model36", "36");
insert into network_addresses VALUES("ip_address36", "fqdn36", "interface36", "BHost36");
insert into operating_systems (`name`, `version`) VALUES("OS_name36", "version36");
insert into physical_systems VALUES("BHost36", "serial36", "36", "36", "36", "assetTag36");
insert into systems_projects VALUES("BHost36", "project_name36");
insert into datacenter VALUES("datacenter37", "dc_address37");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row37", "rack_column37", "datacenter37" );
insert into customers VALUES("customer_name37", "cust@email37.com");
insert into projects VALUES("project_name37", "customer_name37");
insert into administrators VALUES("username37", "name37");
insert into administrators_projects VALUES("username37", "project_name37", "role37");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment37", "BHost37", "username37");
insert into models (`make`, `model`, `height`) VALUES("make37", "model37", "37");
insert into network_addresses VALUES("ip_address37", "fqdn37", "interface37", "BHost37");
insert into operating_systems (`name`, `version`) VALUES("OS_name37", "version37");
insert into physical_systems VALUES("BHost37", "serial37", "37", "37", "37", "assetTag37");
insert into systems_projects VALUES("BHost37", "project_name37");
insert into datacenter VALUES("datacenter38", "dc_address38");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row38", "rack_column38", "datacenter38" );
insert into customers VALUES("customer_name38", "cust@email38.com");
insert into projects VALUES("project_name38", "customer_name38");
insert into administrators VALUES("username38", "name38");
insert into administrators_projects VALUES("username38", "project_name38", "role38");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment38", "BHost38", "username38");
insert into models (`make`, `model`, `height`) VALUES("make38", "model38", "38");
insert into network_addresses VALUES("ip_address38", "fqdn38", "interface38", "BHost38");
insert into operating_systems (`name`, `version`) VALUES("OS_name38", "version38");
insert into physical_systems VALUES("BHost38", "serial38", "38", "38", "38", "assetTag38");
insert into systems_projects VALUES("BHost38", "project_name38");
insert into datacenter VALUES("datacenter39", "dc_address39");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row39", "rack_column39", "datacenter39" );
insert into customers VALUES("customer_name39", "cust@email39.com");
insert into projects VALUES("project_name39", "customer_name39");
insert into administrators VALUES("username39", "name39");
insert into administrators_projects VALUES("username39", "project_name39", "role39");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment39", "BHost39", "username39");
insert into models (`make`, `model`, `height`) VALUES("make39", "model39", "39");
insert into network_addresses VALUES("ip_address39", "fqdn39", "interface39", "BHost39");
insert into operating_systems (`name`, `version`) VALUES("OS_name39", "version39");
insert into physical_systems VALUES("BHost39", "serial39", "39", "39", "39", "assetTag39");
insert into systems_projects VALUES("BHost39", "project_name39");
insert into datacenter VALUES("datacenter40", "dc_address40");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row40", "rack_column40", "datacenter40" );
insert into customers VALUES("customer_name40", "cust@email40.com");
insert into projects VALUES("project_name40", "customer_name40");
insert into administrators VALUES("username40", "name40");
insert into administrators_projects VALUES("username40", "project_name40", "role40");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment40", "BHost40", "username40");
insert into models (`make`, `model`, `height`) VALUES("make40", "model40", "40");
insert into network_addresses VALUES("ip_address40", "fqdn40", "interface40", "BHost40");
insert into operating_systems (`name`, `version`) VALUES("OS_name40", "version40");
insert into physical_systems VALUES("BHost40", "serial40", "40", "40", "40", "assetTag40");
insert into systems_projects VALUES("BHost40", "project_name40");
insert into datacenter VALUES("datacenter41", "dc_address41");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row41", "rack_column41", "datacenter41" );
insert into customers VALUES("customer_name41", "cust@email41.com");
insert into projects VALUES("project_name41", "customer_name41");
insert into administrators VALUES("username41", "name41");
insert into administrators_projects VALUES("username41", "project_name41", "role41");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment41", "BHost41", "username41");
insert into models (`make`, `model`, `height`) VALUES("make41", "model41", "41");
insert into network_addresses VALUES("ip_address41", "fqdn41", "interface41", "BHost41");
insert into operating_systems (`name`, `version`) VALUES("OS_name41", "version41");
insert into physical_systems VALUES("BHost41", "serial41", "41", "41", "41", "assetTag41");
insert into systems_projects VALUES("BHost41", "project_name41");
insert into datacenter VALUES("datacenter42", "dc_address42");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row42", "rack_column42", "datacenter42" );
insert into customers VALUES("customer_name42", "cust@email42.com");
insert into projects VALUES("project_name42", "customer_name42");
insert into administrators VALUES("username42", "name42");
insert into administrators_projects VALUES("username42", "project_name42", "role42");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment42", "BHost42", "username42");
insert into models (`make`, `model`, `height`) VALUES("make42", "model42", "42");
insert into network_addresses VALUES("ip_address42", "fqdn42", "interface42", "BHost42");
insert into operating_systems (`name`, `version`) VALUES("OS_name42", "version42");
insert into physical_systems VALUES("BHost42", "serial42", "42", "42", "42", "assetTag42");
insert into systems_projects VALUES("BHost42", "project_name42");
insert into datacenter VALUES("datacenter43", "dc_address43");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row43", "rack_column43", "datacenter43" );
insert into customers VALUES("customer_name43", "cust@email43.com");
insert into projects VALUES("project_name43", "customer_name43");
insert into administrators VALUES("username43", "name43");
insert into administrators_projects VALUES("username43", "project_name43", "role43");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment43", "BHost43", "username43");
insert into models (`make`, `model`, `height`) VALUES("make43", "model43", "43");
insert into network_addresses VALUES("ip_address43", "fqdn43", "interface43", "BHost43");
insert into operating_systems (`name`, `version`) VALUES("OS_name43", "version43");
insert into physical_systems VALUES("BHost43", "serial43", "43", "43", "43", "assetTag43");
insert into systems_projects VALUES("BHost43", "project_name43");
insert into datacenter VALUES("datacenter44", "dc_address44");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row44", "rack_column44", "datacenter44" );
insert into customers VALUES("customer_name44", "cust@email44.com");
insert into projects VALUES("project_name44", "customer_name44");
insert into administrators VALUES("username44", "name44");
insert into administrators_projects VALUES("username44", "project_name44", "role44");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment44", "BHost44", "username44");
insert into models (`make`, `model`, `height`) VALUES("make44", "model44", "44");
insert into network_addresses VALUES("ip_address44", "fqdn44", "interface44", "BHost44");
insert into operating_systems (`name`, `version`) VALUES("OS_name44", "version44");
insert into physical_systems VALUES("BHost44", "serial44", "44", "44", "44", "assetTag44");
insert into systems_projects VALUES("BHost44", "project_name44");
insert into datacenter VALUES("datacenter45", "dc_address45");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row45", "rack_column45", "datacenter45" );
insert into customers VALUES("customer_name45", "cust@email45.com");
insert into projects VALUES("project_name45", "customer_name45");
insert into administrators VALUES("username45", "name45");
insert into administrators_projects VALUES("username45", "project_name45", "role45");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment45", "BHost45", "username45");
insert into models (`make`, `model`, `height`) VALUES("make45", "model45", "45");
insert into network_addresses VALUES("ip_address45", "fqdn45", "interface45", "BHost45");
insert into operating_systems (`name`, `version`) VALUES("OS_name45", "version45");
insert into physical_systems VALUES("BHost45", "serial45", "45", "45", "45", "assetTag45");
insert into systems_projects VALUES("BHost45", "project_name45");
insert into datacenter VALUES("datacenter46", "dc_address46");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row46", "rack_column46", "datacenter46" );
insert into customers VALUES("customer_name46", "cust@email46.com");
insert into projects VALUES("project_name46", "customer_name46");
insert into administrators VALUES("username46", "name46");
insert into administrators_projects VALUES("username46", "project_name46", "role46");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment46", "BHost46", "username46");
insert into models (`make`, `model`, `height`) VALUES("make46", "model46", "46");
insert into network_addresses VALUES("ip_address46", "fqdn46", "interface46", "BHost46");
insert into operating_systems (`name`, `version`) VALUES("OS_name46", "version46");
insert into physical_systems VALUES("BHost46", "serial46", "46", "46", "46", "assetTag46");
insert into systems_projects VALUES("BHost46", "project_name46");
insert into datacenter VALUES("datacenter47", "dc_address47");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row47", "rack_column47", "datacenter47" );
insert into customers VALUES("customer_name47", "cust@email47.com");
insert into projects VALUES("project_name47", "customer_name47");
insert into administrators VALUES("username47", "name47");
insert into administrators_projects VALUES("username47", "project_name47", "role47");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment47", "BHost47", "username47");
insert into models (`make`, `model`, `height`) VALUES("make47", "model47", "47");
insert into network_addresses VALUES("ip_address47", "fqdn47", "interface47", "BHost47");
insert into operating_systems (`name`, `version`) VALUES("OS_name47", "version47");
insert into physical_systems VALUES("BHost47", "serial47", "47", "47", "47", "assetTag47");
insert into systems_projects VALUES("BHost47", "project_name47");
insert into datacenter VALUES("datacenter48", "dc_address48");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row48", "rack_column48", "datacenter48" );
insert into customers VALUES("customer_name48", "cust@email48.com");
insert into projects VALUES("project_name48", "customer_name48");
insert into administrators VALUES("username48", "name48");
insert into administrators_projects VALUES("username48", "project_name48", "role48");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment48", "BHost48", "username48");
insert into models (`make`, `model`, `height`) VALUES("make48", "model48", "48");
insert into network_addresses VALUES("ip_address48", "fqdn48", "interface48", "BHost48");
insert into operating_systems (`name`, `version`) VALUES("OS_name48", "version48");
insert into physical_systems VALUES("BHost48", "serial48", "48", "48", "48", "assetTag48");
insert into systems_projects VALUES("BHost48", "project_name48");
insert into datacenter VALUES("datacenter49", "dc_address49");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row49", "rack_column49", "datacenter49" );
insert into customers VALUES("customer_name49", "cust@email49.com");
insert into projects VALUES("project_name49", "customer_name49");
insert into administrators VALUES("username49", "name49");
insert into administrators_projects VALUES("username49", "project_name49", "role49");
insert into comments (`date`, `comment`, `hostname`, `admin`) VALUES (CURRENT_TIMESTAMP, "comment49", "BHost49", "username49");
insert into models (`make`, `model`, `height`) VALUES("make49", "model49", "49");
insert into network_addresses VALUES("ip_address49", "fqdn49", "interface49", "BHost49");
insert into operating_systems (`name`, `version`) VALUES("OS_name49", "version49");
insert into physical_systems VALUES("BHost49", "serial49", "49", "49", "49", "assetTag49");
insert into systems_projects VALUES("BHost49", "project_name49");
insert into virtual_systems VALUES("BHost1", "BHost2");

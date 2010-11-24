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
insert into systems VALUES("BHost0", "descript", "type_1", "1");
insert into systems VALUES("BHost1", "descript", "type_1", "1");
insert into systems VALUES("BHost2", "descript", "type_1", "1");
insert into systems VALUES("BHost3", "descript", "type_1", "1");
insert into systems VALUES("BHost4", "descript", "type_1", "1");
insert into systems VALUES("BHost5", "descript", "type_1", "1");
insert into systems VALUES("BHost6", "descript", "type_1", "1");
insert into systems VALUES("BHost7", "descript", "type_1", "1");
insert into systems VALUES("BHost8", "descript", "type_1", "1");
insert into systems VALUES("BHost9", "descript", "type_1", "1");
insert into systems VALUES("BHost10", "descript", "type_1", "1");
insert into systems VALUES("BHost11", "descript", "type_1", "1");
insert into systems VALUES("BHost12", "descript", "type_1", "1");
insert into systems VALUES("BHost13", "descript", "type_1", "1");
insert into systems VALUES("BHost14", "descript", "type_1", "1");
insert into systems VALUES("BHost15", "descript", "type_1", "1");
insert into systems VALUES("BHost16", "descript", "type_1", "1");
insert into systems VALUES("BHost17", "descript", "type_1", "1");
insert into systems VALUES("BHost18", "descript", "type_1", "1");
insert into systems VALUES("BHost19", "descript", "type_1", "1");
insert into systems VALUES("BHost20", "descript", "type_1", "1");
insert into systems VALUES("BHost21", "descript", "type_1", "1");
insert into systems VALUES("BHost22", "descript", "type_1", "1");
insert into systems VALUES("BHost23", "descript", "type_1", "1");
insert into systems VALUES("BHost24", "descript", "type_1", "1");
insert into systems VALUES("BHost25", "descript", "type_1", "1");
insert into systems VALUES("BHost26", "descript", "type_1", "1");
insert into systems VALUES("BHost27", "descript", "type_1", "1");
insert into systems VALUES("BHost28", "descript", "type_1", "1");
insert into systems VALUES("BHost29", "descript", "type_1", "1");
insert into systems VALUES("BHost30", "descript", "type_1", "1");
insert into systems VALUES("BHost31", "descript", "type_1", "1");
insert into systems VALUES("BHost32", "descript", "type_1", "1");
insert into systems VALUES("BHost33", "descript", "type_1", "1");
insert into systems VALUES("BHost34", "descript", "type_1", "1");
insert into systems VALUES("BHost35", "descript", "type_1", "1");
insert into systems VALUES("BHost36", "descript", "type_1", "1");
insert into systems VALUES("BHost37", "descript", "type_1", "1");
insert into systems VALUES("BHost38", "descript", "type_1", "1");
insert into systems VALUES("BHost39", "descript", "type_1", "1");
insert into datacenter VALUES("datacenter0", "dc_address0");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row0", "rack_column0", "datacenter0" );
insert into customers VALUES("customer_name0", "cust@email0.com");
insert into projects VALUES("project_name0", "customer_name0");
insert into administrators VALUES("username0", "name0");
insert into administrators_projects VALUES("username0", "project_name0", "role0");
insert into datacenter VALUES("datacenter1", "dc_address1");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row1", "rack_column1", "datacenter1" );
insert into customers VALUES("customer_name1", "cust@email1.com");
insert into projects VALUES("project_name1", "customer_name1");
insert into administrators VALUES("username1", "name1");
insert into administrators_projects VALUES("username1", "project_name1", "role1");
insert into datacenter VALUES("datacenter2", "dc_address2");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row2", "rack_column2", "datacenter2" );
insert into customers VALUES("customer_name2", "cust@email2.com");
insert into projects VALUES("project_name2", "customer_name2");
insert into administrators VALUES("username2", "name2");
insert into administrators_projects VALUES("username2", "project_name2", "role2");
insert into datacenter VALUES("datacenter3", "dc_address3");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row3", "rack_column3", "datacenter3" );
insert into customers VALUES("customer_name3", "cust@email3.com");
insert into projects VALUES("project_name3", "customer_name3");
insert into administrators VALUES("username3", "name3");
insert into administrators_projects VALUES("username3", "project_name3", "role3");
insert into datacenter VALUES("datacenter4", "dc_address4");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row4", "rack_column4", "datacenter4" );
insert into customers VALUES("customer_name4", "cust@email4.com");
insert into projects VALUES("project_name4", "customer_name4");
insert into administrators VALUES("username4", "name4");
insert into administrators_projects VALUES("username4", "project_name4", "role4");
insert into datacenter VALUES("datacenter5", "dc_address5");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row5", "rack_column5", "datacenter5" );
insert into customers VALUES("customer_name5", "cust@email5.com");
insert into projects VALUES("project_name5", "customer_name5");
insert into administrators VALUES("username5", "name5");
insert into administrators_projects VALUES("username5", "project_name5", "role5");
insert into datacenter VALUES("datacenter6", "dc_address6");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row6", "rack_column6", "datacenter6" );
insert into customers VALUES("customer_name6", "cust@email6.com");
insert into projects VALUES("project_name6", "customer_name6");
insert into administrators VALUES("username6", "name6");
insert into administrators_projects VALUES("username6", "project_name6", "role6");
insert into datacenter VALUES("datacenter7", "dc_address7");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row7", "rack_column7", "datacenter7" );
insert into customers VALUES("customer_name7", "cust@email7.com");
insert into projects VALUES("project_name7", "customer_name7");
insert into administrators VALUES("username7", "name7");
insert into administrators_projects VALUES("username7", "project_name7", "role7");
insert into datacenter VALUES("datacenter8", "dc_address8");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row8", "rack_column8", "datacenter8" );
insert into customers VALUES("customer_name8", "cust@email8.com");
insert into projects VALUES("project_name8", "customer_name8");
insert into administrators VALUES("username8", "name8");
insert into administrators_projects VALUES("username8", "project_name8", "role8");
insert into datacenter VALUES("datacenter9", "dc_address9");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row9", "rack_column9", "datacenter9" );
insert into customers VALUES("customer_name9", "cust@email9.com");
insert into projects VALUES("project_name9", "customer_name9");
insert into administrators VALUES("username9", "name9");
insert into administrators_projects VALUES("username9", "project_name9", "role9");
insert into datacenter VALUES("datacenter10", "dc_address10");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row10", "rack_column10", "datacenter10" );
insert into customers VALUES("customer_name10", "cust@email10.com");
insert into projects VALUES("project_name10", "customer_name10");
insert into administrators VALUES("username10", "name10");
insert into administrators_projects VALUES("username10", "project_name10", "role10");
insert into datacenter VALUES("datacenter11", "dc_address11");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row11", "rack_column11", "datacenter11" );
insert into customers VALUES("customer_name11", "cust@email11.com");
insert into projects VALUES("project_name11", "customer_name11");
insert into administrators VALUES("username11", "name11");
insert into administrators_projects VALUES("username11", "project_name11", "role11");
insert into datacenter VALUES("datacenter12", "dc_address12");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row12", "rack_column12", "datacenter12" );
insert into customers VALUES("customer_name12", "cust@email12.com");
insert into projects VALUES("project_name12", "customer_name12");
insert into administrators VALUES("username12", "name12");
insert into administrators_projects VALUES("username12", "project_name12", "role12");
insert into datacenter VALUES("datacenter13", "dc_address13");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row13", "rack_column13", "datacenter13" );
insert into customers VALUES("customer_name13", "cust@email13.com");
insert into projects VALUES("project_name13", "customer_name13");
insert into administrators VALUES("username13", "name13");
insert into administrators_projects VALUES("username13", "project_name13", "role13");
insert into datacenter VALUES("datacenter14", "dc_address14");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row14", "rack_column14", "datacenter14" );
insert into customers VALUES("customer_name14", "cust@email14.com");
insert into projects VALUES("project_name14", "customer_name14");
insert into administrators VALUES("username14", "name14");
insert into administrators_projects VALUES("username14", "project_name14", "role14");
insert into datacenter VALUES("datacenter15", "dc_address15");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row15", "rack_column15", "datacenter15" );
insert into customers VALUES("customer_name15", "cust@email15.com");
insert into projects VALUES("project_name15", "customer_name15");
insert into administrators VALUES("username15", "name15");
insert into administrators_projects VALUES("username15", "project_name15", "role15");
insert into datacenter VALUES("datacenter16", "dc_address16");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row16", "rack_column16", "datacenter16" );
insert into customers VALUES("customer_name16", "cust@email16.com");
insert into projects VALUES("project_name16", "customer_name16");
insert into administrators VALUES("username16", "name16");
insert into administrators_projects VALUES("username16", "project_name16", "role16");
insert into datacenter VALUES("datacenter17", "dc_address17");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row17", "rack_column17", "datacenter17" );
insert into customers VALUES("customer_name17", "cust@email17.com");
insert into projects VALUES("project_name17", "customer_name17");
insert into administrators VALUES("username17", "name17");
insert into administrators_projects VALUES("username17", "project_name17", "role17");
insert into datacenter VALUES("datacenter18", "dc_address18");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row18", "rack_column18", "datacenter18" );
insert into customers VALUES("customer_name18", "cust@email18.com");
insert into projects VALUES("project_name18", "customer_name18");
insert into administrators VALUES("username18", "name18");
insert into administrators_projects VALUES("username18", "project_name18", "role18");
insert into datacenter VALUES("datacenter19", "dc_address19");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row19", "rack_column19", "datacenter19" );
insert into customers VALUES("customer_name19", "cust@email19.com");
insert into projects VALUES("project_name19", "customer_name19");
insert into administrators VALUES("username19", "name19");
insert into administrators_projects VALUES("username19", "project_name19", "role19");
insert into datacenter VALUES("datacenter20", "dc_address20");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row20", "rack_column20", "datacenter20" );
insert into customers VALUES("customer_name20", "cust@email20.com");
insert into projects VALUES("project_name20", "customer_name20");
insert into administrators VALUES("username20", "name20");
insert into administrators_projects VALUES("username20", "project_name20", "role20");
insert into datacenter VALUES("datacenter21", "dc_address21");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row21", "rack_column21", "datacenter21" );
insert into customers VALUES("customer_name21", "cust@email21.com");
insert into projects VALUES("project_name21", "customer_name21");
insert into administrators VALUES("username21", "name21");
insert into administrators_projects VALUES("username21", "project_name21", "role21");
insert into datacenter VALUES("datacenter22", "dc_address22");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row22", "rack_column22", "datacenter22" );
insert into customers VALUES("customer_name22", "cust@email22.com");
insert into projects VALUES("project_name22", "customer_name22");
insert into administrators VALUES("username22", "name22");
insert into administrators_projects VALUES("username22", "project_name22", "role22");
insert into datacenter VALUES("datacenter23", "dc_address23");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row23", "rack_column23", "datacenter23" );
insert into customers VALUES("customer_name23", "cust@email23.com");
insert into projects VALUES("project_name23", "customer_name23");
insert into administrators VALUES("username23", "name23");
insert into administrators_projects VALUES("username23", "project_name23", "role23");
insert into datacenter VALUES("datacenter24", "dc_address24");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row24", "rack_column24", "datacenter24" );
insert into customers VALUES("customer_name24", "cust@email24.com");
insert into projects VALUES("project_name24", "customer_name24");
insert into administrators VALUES("username24", "name24");
insert into administrators_projects VALUES("username24", "project_name24", "role24");
insert into datacenter VALUES("datacenter25", "dc_address25");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row25", "rack_column25", "datacenter25" );
insert into customers VALUES("customer_name25", "cust@email25.com");
insert into projects VALUES("project_name25", "customer_name25");
insert into administrators VALUES("username25", "name25");
insert into administrators_projects VALUES("username25", "project_name25", "role25");
insert into datacenter VALUES("datacenter26", "dc_address26");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row26", "rack_column26", "datacenter26" );
insert into customers VALUES("customer_name26", "cust@email26.com");
insert into projects VALUES("project_name26", "customer_name26");
insert into administrators VALUES("username26", "name26");
insert into administrators_projects VALUES("username26", "project_name26", "role26");
insert into datacenter VALUES("datacenter27", "dc_address27");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row27", "rack_column27", "datacenter27" );
insert into customers VALUES("customer_name27", "cust@email27.com");
insert into projects VALUES("project_name27", "customer_name27");
insert into administrators VALUES("username27", "name27");
insert into administrators_projects VALUES("username27", "project_name27", "role27");
insert into datacenter VALUES("datacenter28", "dc_address28");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row28", "rack_column28", "datacenter28" );
insert into customers VALUES("customer_name28", "cust@email28.com");
insert into projects VALUES("project_name28", "customer_name28");
insert into administrators VALUES("username28", "name28");
insert into administrators_projects VALUES("username28", "project_name28", "role28");
insert into datacenter VALUES("datacenter29", "dc_address29");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row29", "rack_column29", "datacenter29" );
insert into customers VALUES("customer_name29", "cust@email29.com");
insert into projects VALUES("project_name29", "customer_name29");
insert into administrators VALUES("username29", "name29");
insert into administrators_projects VALUES("username29", "project_name29", "role29");
insert into datacenter VALUES("datacenter30", "dc_address30");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row30", "rack_column30", "datacenter30" );
insert into customers VALUES("customer_name30", "cust@email30.com");
insert into projects VALUES("project_name30", "customer_name30");
insert into administrators VALUES("username30", "name30");
insert into administrators_projects VALUES("username30", "project_name30", "role30");
insert into datacenter VALUES("datacenter31", "dc_address31");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row31", "rack_column31", "datacenter31" );
insert into customers VALUES("customer_name31", "cust@email31.com");
insert into projects VALUES("project_name31", "customer_name31");
insert into administrators VALUES("username31", "name31");
insert into administrators_projects VALUES("username31", "project_name31", "role31");
insert into datacenter VALUES("datacenter32", "dc_address32");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row32", "rack_column32", "datacenter32" );
insert into customers VALUES("customer_name32", "cust@email32.com");
insert into projects VALUES("project_name32", "customer_name32");
insert into administrators VALUES("username32", "name32");
insert into administrators_projects VALUES("username32", "project_name32", "role32");
insert into datacenter VALUES("datacenter33", "dc_address33");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row33", "rack_column33", "datacenter33" );
insert into customers VALUES("customer_name33", "cust@email33.com");
insert into projects VALUES("project_name33", "customer_name33");
insert into administrators VALUES("username33", "name33");
insert into administrators_projects VALUES("username33", "project_name33", "role33");
insert into datacenter VALUES("datacenter34", "dc_address34");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row34", "rack_column34", "datacenter34" );
insert into customers VALUES("customer_name34", "cust@email34.com");
insert into projects VALUES("project_name34", "customer_name34");
insert into administrators VALUES("username34", "name34");
insert into administrators_projects VALUES("username34", "project_name34", "role34");
insert into datacenter VALUES("datacenter35", "dc_address35");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row35", "rack_column35", "datacenter35" );
insert into customers VALUES("customer_name35", "cust@email35.com");
insert into projects VALUES("project_name35", "customer_name35");
insert into administrators VALUES("username35", "name35");
insert into administrators_projects VALUES("username35", "project_name35", "role35");
insert into datacenter VALUES("datacenter36", "dc_address36");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row36", "rack_column36", "datacenter36" );
insert into customers VALUES("customer_name36", "cust@email36.com");
insert into projects VALUES("project_name36", "customer_name36");
insert into administrators VALUES("username36", "name36");
insert into administrators_projects VALUES("username36", "project_name36", "role36");
insert into datacenter VALUES("datacenter37", "dc_address37");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row37", "rack_column37", "datacenter37" );
insert into customers VALUES("customer_name37", "cust@email37.com");
insert into projects VALUES("project_name37", "customer_name37");
insert into administrators VALUES("username37", "name37");
insert into administrators_projects VALUES("username37", "project_name37", "role37");
insert into datacenter VALUES("datacenter38", "dc_address38");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row38", "rack_column38", "datacenter38" );
insert into customers VALUES("customer_name38", "cust@email38.com");
insert into projects VALUES("project_name38", "customer_name38");
insert into administrators VALUES("username38", "name38");
insert into administrators_projects VALUES("username38", "project_name38", "role38");
insert into datacenter VALUES("datacenter39", "dc_address39");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row39", "rack_column39", "datacenter39" );
insert into customers VALUES("customer_name39", "cust@email39.com");
insert into projects VALUES("project_name39", "customer_name39");
insert into administrators VALUES("username39", "name39");
insert into administrators_projects VALUES("username39", "project_name39", "role39");
insert into datacenter VALUES("datacenter40", "dc_address40");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row40", "rack_column40", "datacenter40" );
insert into customers VALUES("customer_name40", "cust@email40.com");
insert into projects VALUES("project_name40", "customer_name40");
insert into administrators VALUES("username40", "name40");
insert into administrators_projects VALUES("username40", "project_name40", "role40");
insert into datacenter VALUES("datacenter41", "dc_address41");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row41", "rack_column41", "datacenter41" );
insert into customers VALUES("customer_name41", "cust@email41.com");
insert into projects VALUES("project_name41", "customer_name41");
insert into administrators VALUES("username41", "name41");
insert into administrators_projects VALUES("username41", "project_name41", "role41");
insert into datacenter VALUES("datacenter42", "dc_address42");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row42", "rack_column42", "datacenter42" );
insert into customers VALUES("customer_name42", "cust@email42.com");
insert into projects VALUES("project_name42", "customer_name42");
insert into administrators VALUES("username42", "name42");
insert into administrators_projects VALUES("username42", "project_name42", "role42");
insert into datacenter VALUES("datacenter43", "dc_address43");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row43", "rack_column43", "datacenter43" );
insert into customers VALUES("customer_name43", "cust@email43.com");
insert into projects VALUES("project_name43", "customer_name43");
insert into administrators VALUES("username43", "name43");
insert into administrators_projects VALUES("username43", "project_name43", "role43");
insert into datacenter VALUES("datacenter44", "dc_address44");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row44", "rack_column44", "datacenter44" );
insert into customers VALUES("customer_name44", "cust@email44.com");
insert into projects VALUES("project_name44", "customer_name44");
insert into administrators VALUES("username44", "name44");
insert into administrators_projects VALUES("username44", "project_name44", "role44");
insert into datacenter VALUES("datacenter45", "dc_address45");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row45", "rack_column45", "datacenter45" );
insert into customers VALUES("customer_name45", "cust@email45.com");
insert into projects VALUES("project_name45", "customer_name45");
insert into administrators VALUES("username45", "name45");
insert into administrators_projects VALUES("username45", "project_name45", "role45");
insert into datacenter VALUES("datacenter46", "dc_address46");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row46", "rack_column46", "datacenter46" );
insert into customers VALUES("customer_name46", "cust@email46.com");
insert into projects VALUES("project_name46", "customer_name46");
insert into administrators VALUES("username46", "name46");
insert into administrators_projects VALUES("username46", "project_name46", "role46");
insert into datacenter VALUES("datacenter47", "dc_address47");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row47", "rack_column47", "datacenter47" );
insert into customers VALUES("customer_name47", "cust@email47.com");
insert into projects VALUES("project_name47", "customer_name47");
insert into administrators VALUES("username47", "name47");
insert into administrators_projects VALUES("username47", "project_name47", "role47");
insert into datacenter VALUES("datacenter48", "dc_address48");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row48", "rack_column48", "datacenter48" );
insert into customers VALUES("customer_name48", "cust@email48.com");
insert into projects VALUES("project_name48", "customer_name48");
insert into administrators VALUES("username48", "name48");
insert into administrators_projects VALUES("username48", "project_name48", "role48");
insert into datacenter VALUES("datacenter49", "dc_address49");
insert into cabinets(`row`, `column`, datacenter_name) VALUES("rack_row49", "rack_column49", "datacenter49" );
insert into customers VALUES("customer_name49", "cust@email49.com");
insert into projects VALUES("project_name49", "customer_name49");
insert into administrators VALUES("username49", "name49");
insert into administrators_projects VALUES("username49", "project_name49", "role49");

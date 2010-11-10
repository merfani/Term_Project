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
`row` VARCHAR(20) NOT NULL,
`column` VARCHAR(20) NOT NULL,
`id` INT NOT NULL AUTO_INCREMENT,
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

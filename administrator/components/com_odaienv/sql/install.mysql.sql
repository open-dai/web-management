CREATE TABLE IF NOT EXISTS `#__odai_vms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `#__odai_vdbs` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(45) default NULL,
  `vdbfile` varchar(80) default NULL,
  `state` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `#__odai_resources` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(45) default NULL,
  `state` int(11) default NULL,
  `jndiname` varchar(45) default NULL,
  `resfile` varchar(80) default NULL,
  `vdb_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `#__odai_resources_FK1` (`vdb_id`),
  CONSTRAINT `#__odai_resources_FK1` FOREIGN KEY (`vdb_id`) REFERENCES `#__odai_vdbs` (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `#__odai_datasources` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(45) default NULL,
  `state` int(11) default NULL,
  `jndiname` varchar(45) default NULL,
  `drivername` varchar(45) default NULL,
  `driverclass` varchar(45) default NULL,
  `connectionurl` varchar(100) default NULL,
  `user` varchar(45) default NULL,
  `password` varchar(45) default NULL,
  `vdb_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `#__odai_datasources_FK1` (`vdb_id`),
  CONSTRAINT `#__odai_datasources_FK1` FOREIGN KEY (`vdb_id`) REFERENCES `#__odai_vdbs` (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `#__odai_apis` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(45) default NULL,
  `state` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
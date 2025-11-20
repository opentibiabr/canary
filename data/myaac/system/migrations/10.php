<?php
	if(!$db->hasColumn(TABLE_PREFIX . 'hooks', 'ordering'))
		$db->query("ALTER TABLE `" . TABLE_PREFIX . "hooks` ADD `ordering` INT(11) NOT NULL DEFAULT 0 AFTER `file`;");

	if(!$db->hasTable(TABLE_PREFIX . 'admin_menu'))
		$db->query("
CREATE TABLE `myaac_admin_menu`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL DEFAULT '',
	`page` VARCHAR(255) NOT NULL DEFAULT '',
	`ordering` INT(11) NOT NULL DEFAULT 0,
	`flags` INT(11) NOT NULL DEFAULT 0,
	`enabled` INT(1) NOT NULL DEFAULT 1,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;
");
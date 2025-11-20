<?php
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "account_actions` MODIFY `ip` INT(11) NOT NULL DEFAULT 0;");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "account_actions` MODIFY `date` INT(11) NOT NULL DEFAULT 0;");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "account_actions` MODIFY `action` VARCHAR(255) NOT NULL DEFAULT '';");
	$db->query("
	CREATE TABLE `myaac_hooks`
(
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL DEFAULT '',
	`type` INT(2) NOT NULL DEFAULT 0,
	`file` VARCHAR(100) NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;
");

?>
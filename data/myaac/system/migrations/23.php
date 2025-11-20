<?php

if(!$db->hasColumn(TABLE_PREFIX . 'menu', 'blank'))
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "menu` ADD `blank` TINYINT(1) NOT NULL DEFAULT 0 AFTER `link`;");

if(!$db->hasColumn(TABLE_PREFIX . 'menu', 'color'))
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "menu` ADD `color` CHAR(6) NOT NULL DEFAULT '' AFTER `blank`;");
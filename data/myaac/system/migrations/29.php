<?php

if(!$db->hasColumn(TABLE_PREFIX . 'pages', 'enable_tinymce')) {
	$db->exec('ALTER TABLE `' . TABLE_PREFIX . 'pages` ADD `enable_tinymce` TINYINT(1) NOT NULL DEFAULT 1 COMMENT \'1 - enabled, 0 - disabled\' AFTER `php`;');
}

<?php
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "account_actions` ADD `ipv6` BINARY(16) NOT NULL DEFAULT 0;");
?>
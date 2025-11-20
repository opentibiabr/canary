<?php
	if(!$db->hasColumn(TABLE_PREFIX . 'monsters', 'id'))
		$db->query("ALTER TABLE `" . TABLE_PREFIX . "monsters` ADD `id` int(11) NOT NULL AUTO_INCREMENT primary key FIRST;");
?>
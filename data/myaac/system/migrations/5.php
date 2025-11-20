<?php
	if($db->hasColumn(TABLE_PREFIX . 'spells', 'cities'))
		$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` DROP COLUMN cities;");
?>
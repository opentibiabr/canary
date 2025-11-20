<?php
	if($db->hasColumn(TABLE_PREFIX . 'spells', 'spell'))
		$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` DROP COLUMN `spell`;");
?>
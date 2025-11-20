<?php
	if($db->hasColumn(TABLE_PREFIX . 'screenshots', 'name'))
		$db->query("ALTER TABLE `" . TABLE_PREFIX . "screenshots` DROP `name`;");
?>
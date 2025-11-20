<?php
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "bugtracker` MODIFY `type` INT(11) NOT NULL DEFAULT 0;");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "bugtracker` MODIFY `status` INT(11) NOT NULL DEFAULT 0;");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "bugtracker` MODIFY `id` INT(11) NOT NULL DEFAULT 0;");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "bugtracker` MODIFY `subject` VARCHAR(255) NOT NULL DEFAULT '';");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "bugtracker` MODIFY `reply` INT(11) NOT NULL DEFAULT 0;");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "bugtracker` MODIFY `who` INT(11) NOT NULL DEFAULT 0;");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "bugtracker` MODIFY `tag` INT(11) NOT NULL DEFAULT 0;");
?>
<?php
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "faq` MODIFY `answer` VARCHAR(1020) NOT NULL DEFAULT '';");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "movies` MODIFY `title` VARCHAR(100) NOT NULL DEFAULT '';");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "news` MODIFY `title` VARCHAR(100) NOT NULL DEFAULT '';");
	$db->query("ALTER TABLE `" . TABLE_PREFIX . "news` MODIFY `body` TEXT NOT NULL DEFAULT '';");
?>

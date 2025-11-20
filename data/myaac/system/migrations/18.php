<?php

$db->query("ALTER TABLE `" . TABLE_PREFIX . "news` ADD `article_text` VARCHAR(300) NOT NULL DEFAULT '' AFTER `comments`;");
$db->query("ALTER TABLE `" . TABLE_PREFIX . "news` ADD `article_image` VARCHAR(100) NOT NULL DEFAULT '' AFTER `article_text`;");

?>
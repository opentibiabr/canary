<?php

if (!$db->hasColumn($table = 'accounts', 'phone')) {
    $db->exec("ALTER TABLE `{$table}` ADD `phone` VARCHAR(15) NULL AFTER `rlname`;");
}

if (!$db->hasColumn($table = 'players', 'ismain')) {
    $db->exec("ALTER TABLE `{$table}` ADD `ismain` TINYINT(1) NOT NULL DEFAULT 0 AFTER `istutorial`;");
}

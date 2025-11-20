<?php
// Alter column type so we can have bigger pages.
$db->exec('ALTER TABLE myaac_pages CHANGE body body LONGTEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL;');

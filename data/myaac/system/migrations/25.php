<?php

$db->exec('ALTER TABLE `' . TABLE_PREFIX . 'monsters` MODIFY `loot` text NOT NULL;');
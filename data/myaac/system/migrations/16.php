<?php

// change size of spells.vocations
$db->query("ALTER TABLE `" . TABLE_PREFIX . "spells` MODIFY `vocations` VARCHAR(300) NOT NULL DEFAULT '';");
?>
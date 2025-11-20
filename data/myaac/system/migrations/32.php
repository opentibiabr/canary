<?php
// Increase size of page in myaac_visitors table

$db->exec('ALTER TABLE `' . TABLE_PREFIX . "visitors` MODIFY `page` VARCHAR(2048) NOT NULL;");

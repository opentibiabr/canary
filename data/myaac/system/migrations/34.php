<?php
// Increase size of ip in myaac_visitors table
// according to this answer: https://stackoverflow.com/questions/166132/maximum-length-of-the-textual-representation-of-an-ipv6-address
// the size of ipv6 can be maximal 45 chars

$db->exec('ALTER TABLE `' . TABLE_PREFIX . 'visitors` MODIFY `ip` VARCHAR(45) NOT NULL;');

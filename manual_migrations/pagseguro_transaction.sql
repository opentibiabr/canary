CREATE TABLE IF NOT EXISTS `pagseguro_transactions` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `transaction_code` VARCHAR(50) NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `payment_method` VARCHAR(50) NOT NULL,
  `payment_status` VARCHAR(50) NOT NULL,
  `code` VARCHAR(10) NOT NULL,
  `coins_amount` INT(11) NOT NULL,
  `bought` INT(11) DEFAULT NULL,
  `delivered` CHAR(1) NOT NULL DEFAULT '0',
  `in_double` CHAR(1) NOT NULL DEFAULT '0',
  `request` LONGTEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME DEFAULT NULL,
  UNIQUE KEY `transaction_code` (`transaction_code`, `payment_status`),
  CONSTRAINT `pagseguro_transactions_account_fk`
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
  ON DELETE CASCADE,
  INDEX `payment_method` (`payment_method`),
  INDEX `payment_status` (`payment_status`),
  INDEX `coins_amount` (`coins_amount`),
  INDEX `delivered` (`delivered`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

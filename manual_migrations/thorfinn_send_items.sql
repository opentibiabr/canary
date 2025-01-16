CREATE TABLE IF NOT EXISTS `thorfinn_send_items` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `transaction_code` VARCHAR(50) NOT NULL,
  `item_id` VARCHAR(20) NOT NULL,
  `item_name` VARCHAR(50) NOT NULL,
  `item_count` int(11) UNSIGNED NOT NULL DEFAULT 1,
  `account_id` int(11) UNSIGNED NOT NULL,
  `payment_method` VARCHAR(50) NOT NULL,
  `payment_status` VARCHAR(50) NOT NULL,
  `status` CHAR(1) NOT NULL DEFAULT '0' COMMENT '0 = pending | 1 = approved | 2 = delivered | 3 = canceled',
  `request` LONGTEXT DEFAULT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME DEFAULT NULL,
  UNIQUE KEY `transaction_code` (`transaction_code`, `payment_status`),
  CONSTRAINT `thorfinn_send_items_account_fk`
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
  ON DELETE CASCADE,
  INDEX `status` (`status`),
  INDEX `payment_method` (`payment_method`),
  INDEX `payment_status` (`payment_status`)
) ENGINE=InnoDB DEFAULT CHARACTER SET=utf8;

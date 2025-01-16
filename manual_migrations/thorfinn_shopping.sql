CREATE TABLE IF NOT EXISTS `thorfinn_shopping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` int(11) UNSIGNED NOT NULL,
  `item_id` int(11) UNSIGNED NOT NULL,
  `item_count` int(11) UNSIGNED NOT NULL,
  `item_charges` int(11) NULL DEFAULT 0,
  `item_tier` int(11) NULL DEFAULT 0,
  `value` int(11) UNSIGNED NOT NULL,
  `account_id` int(11) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `player_name` varchar(100) NOT NULL,
  `bought_by` int(11) NULL,
  `enabled` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `sold` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `canceled` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
  `created_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  INDEX `account_id` (`account_id`),
  INDEX `player_id` (`player_id`),
  INDEX `bought_by` (`bought_by`),
  CONSTRAINT `thorfinn_shopping_pk` PRIMARY KEY (`id`),
  CONSTRAINT `thorfinn_shopping_account_fk`
  FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
  ON DELETE CASCADE,
  CONSTRAINT `thorfinn_shopping_player_fk`
  FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
  ON DELETE CASCADE,
  CONSTRAINT `thorfinn_shopping_bought_by_fk`
  FOREIGN KEY (`bought_by`) REFERENCES `players` (`id`)
  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

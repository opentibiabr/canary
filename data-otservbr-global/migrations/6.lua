function onUpdateDatabase()
	logger.info("Updating database to version 6 (Stash supply)")
	db.query([[CREATE TABLE IF NOT EXISTS `player_stash` (
  `player_id` INT(16) NOT NULL,
  `item_id` INT(16) NOT NULL,
  `item_count` INT(32) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;]])
end

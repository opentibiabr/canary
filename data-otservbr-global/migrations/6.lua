function onUpdateDatabase()
  Spdlog.info("Updating database to version 7 (Stash supply)")
  db.query([[CREATE TABLE IF NOT EXISTS `player_stash` (
  `player_id` INT(16) NOT NULL,
  `item_id` INT(16) NOT NULL,
  `item_count` INT(32) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;]])
  return true -- true = There are others migrations file | false = this is the last migration file
end

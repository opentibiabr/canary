function onUpdateDatabase()
  Spdlog.info("Updating database to version 9 (Bestiary cpp)")
  db.query([[CREATE TABLE IF NOT EXISTS `player_charms` (
`player_guid` INT(250) NOT NULL , 
`charm_points` VARCHAR(250) NULL , 
`charm_expansion` BOOLEAN NULL , 
`rune_wound` INT(250) NULL , 
`rune_enflame` INT(250) NULL , 
`rune_poison` INT(250) NULL ,
`rune_freeze` INT(250) NULL ,
`rune_zap` INT(250) NULL ,
`rune_curse` INT(250) NULL ,
`rune_cripple` INT(250) NULL ,
`rune_parry` INT(250) NULL ,
`rune_dodge` INT(250) NULL ,
`rune_adrenaline` INT(250) NULL ,
`rune_numb` INT(250) NULL, 
`rune_cleanse` INT(250) NULL ,
`rune_bless` INT(250) NULL ,
`rune_scavenge` INT(250) NULL ,
`rune_gut` INT(250) NULL ,
`rune_low_blow` INT(250) NULL ,
`rune_divine` INT(250) NULL ,
`rune_vamp` INT(250) NULL ,
`rune_void` INT(250) NULL ,
`UsedRunesBit` VARCHAR(250) NULL ,
`UnlockedRunesBit` VARCHAR(250) NULL,
`tracker list` BLOB NULL ) ENGINE = InnoDB DEFAULT CHARSET=utf8;]])  
    return true -- true = There are others migrations file | false = this is the last migration file
end

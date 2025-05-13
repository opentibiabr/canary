function onUpdateDatabase()
	logger.info("Updating database to version 50 (feat: support to 14.11)")

	db.query([[
		ALTER TABLE `player_charms`
		DROP `rune_wound`,
		DROP `rune_enflame`,
		DROP `rune_poison`,
		DROP `rune_freeze`,
		DROP `rune_zap`,
		DROP `rune_curse`,
		DROP `rune_cripple`,
		DROP `rune_parry`,
		DROP `rune_dodge`,
		DROP `rune_adrenaline`,
		DROP `rune_numb`,
		DROP `rune_cleanse`,
		DROP `rune_bless`,
		DROP `rune_scavenge`,
		DROP `rune_gut`,
		DROP `rune_low_blow`,
		DROP `rune_divine`,
		DROP `rune_vamp`,
		DROP `rune_void`
	]])

	db.query([[
		ALTER TABLE `player_charms`
		ADD `minor_charm_echoes` SMALLINT NOT NULL DEFAULT '0',
		ADD `max_charm_points` SMALLINT NOT NULL DEFAULT '0',
		ADD `max_minor_charm_echoes` SMALLINT NOT NULL DEFAULT '0',
		ADD `charms` BLOB NULL
	]])

	db.query([[
		ALTER TABLE `player_charms`
		MODIFY COLUMN `charm_points` SMALLINT NOT NULL DEFAULT '0',
		MODIFY COLUMN `UsedRunesBit` INT NOT NULL DEFAULT '0',
		MODIFY COLUMN `UnlockedRunesBit` INT NOT NULL DEFAULT '0',
		MODIFY COLUMN `charm_expansion` BOOLEAN NOT NULL DEFAULT FALSE,
		CHANGE COLUMN `player_guid` `player_id` int(11) NOT NULL
	]])

	db.query([[
		ALTER TABLE player_charms
		ADD CONSTRAINT player_charms_players_fk
		FOREIGN KEY (player_id) REFERENCES players (id)
	]])

	db.query([[
		UPDATE `player_charms` pc
		JOIN `players` p ON pc.player_id = p.id
		SET 
			pc.minor_charm_echoes = 100,
			pc.max_minor_charm_echoes = 100
		WHERE p.vocation >= 5
	]])
end

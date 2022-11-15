function onUpdateDatabase()
    Spdlog.info("Updating database to version 2 (hireling)")

    db.query([[
		CREATE TABLE IF NOT EXISTS `player_hirelings` (
            `id` INT NOT NULL PRIMARY KEY auto_increment,
            `player_id` INT NOT NULL,
            `name` varchar(255),
            `active` tinyint unsigned NOT NULL DEFAULT '0',
            `sex` tinyint unsigned NOT NULL DEFAULT '0',
            `posx` int(11) NOT NULL DEFAULT '0',
            `posy` int(11) NOT NULL DEFAULT '0',
            `posz` int(11) NOT NULL DEFAULT '0',
            `lookbody` int(11) NOT NULL DEFAULT '0',
            `lookfeet` int(11) NOT NULL DEFAULT '0',
            `lookhead` int(11) NOT NULL DEFAULT '0',
            `looklegs` int(11) NOT NULL DEFAULT '0',
            `looktype` int(11) NOT NULL DEFAULT '136',

            FOREIGN KEY(`player_id`) REFERENCES `players`(`id`)
                ON DELETE CASCADE
		)
	]])

    return true
end

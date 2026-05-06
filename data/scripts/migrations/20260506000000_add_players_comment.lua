local migration = Migration("20260506000000_add_players_comment")

function migration:onExecute()
	local column = db.storeQuery("SHOW COLUMNS FROM `players` LIKE 'comment'")
	if column then
		Result.free(column)
		return
	end

	db.query("ALTER TABLE `players` ADD COLUMN `comment` varchar(255) NOT NULL DEFAULT '' AFTER `boss_points`")
end

migration:register()

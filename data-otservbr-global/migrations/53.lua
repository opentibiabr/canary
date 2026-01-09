function onUpdateDatabase()
	logger.info("Updating database to version 53 (player forge history unique done_at)")

	db.query([[
		UPDATE forge_history
		SET done_at = done_at * 1000
		WHERE done_at < 1000000000000;
	]])

	db.query([[
		UPDATE forge_history AS f1
		JOIN (
			SELECT
				id,
				player_id,
				done_at,
				ROW_NUMBER() OVER (PARTITION BY player_id, done_at ORDER BY id) AS row_num
			FROM forge_history
		) AS duplicates ON f1.id = duplicates.id
		SET f1.done_at = f1.done_at + (duplicates.row_num * 1)
		WHERE duplicates.row_num > 1;
	]])

	local success = db.query("ALTER TABLE forge_history ADD UNIQUE KEY unique_player_done_at (player_id, done_at);")

	if not success then
		logger.error("Failed to add unique key to 'player_id, done_at'.")
		return false
	end

	return true
end

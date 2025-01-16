function onUpdateDatabase()
	logger.info("Updating database to version 26 (reward bag fix)")
	db.query("UPDATE player_rewards SET pid = 0 WHERE itemtype = 19202;")
	return true
end

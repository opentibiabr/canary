function onUpdateDatabase()
    logger.info("Updating database to version 54 (set community manager and god to type/group 6)")

    local updateAccounts = db.query([[UPDATE accounts SET type = 6 WHERE type = 5;]])
    local updatePlayers = db.query([[UPDATE players SET group_id = 6 WHERE group_id = 5;]])

    if not updateAccounts or not updatePlayers then
        logger.error("Failed to migrate god group values to 6.")
        return false
    end

    return true
end

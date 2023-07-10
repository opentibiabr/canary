function onUpdateDatabase()
    Spdlog.info("Updating database to version 4 (prey tick)")

    db.query([[
        ALTER TABLE `prey_slots`
            ADD `tick` smallint(3) NOT NULL DEFAULT '0';
    ]])
    return true
end

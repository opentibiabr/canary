function onUpdateDatabase()
	logger.info("Updating database to version 3 (prey tick)")

	db.query([[
        ALTER TABLE `prey_slots`
            ADD `tick` smallint(3) NOT NULL DEFAULT '0';
    ]])
end

function onUpdateDatabase()
	print("> Updating database to version 17 (Tutorial support)")
    db.query("ALTER TABLE `players` ADD `istutorial` SMALLINT(1) NOT NULL DEFAULT '0'")
	return true -- true = There are others migrations file | false = this is the last migration file
end

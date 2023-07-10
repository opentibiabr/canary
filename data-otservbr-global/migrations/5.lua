function onUpdateDatabase()
    Spdlog.info("Updating database to version 6 (quickloot)")
    db.query("ALTER TABLE `players` ADD `quickloot_fallback` TINYINT DEFAULT 0")
    return true
end

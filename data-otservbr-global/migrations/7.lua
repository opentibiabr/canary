function onUpdateDatabase()
    Spdlog.info("Updating database to version 8 (recruiter system)")
    db.query("ALTER TABLE `accounts` ADD `recruiter` INT(6) DEFAULT 0")
    return true
end

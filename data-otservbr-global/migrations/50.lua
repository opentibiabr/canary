function onUpdateDatabase()
    logger.info("Updating database to version 50 (Drome Highscores and Rewards)")

    db.query([[ 
        CREATE TABLE IF NOT EXISTS drome_highscores (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            player_id INT NOT NULL,
            player_name VARCHAR(255) NOT NULL,
            highscore INT NOT NULL DEFAULT 0,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY (player_id),
            FOREIGN KEY (player_id) REFERENCES players (id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    ]])

    db.query([[ 
        CREATE TABLE IF NOT EXISTS drome_reset (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            last_reset TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
    ]])

    db.query([[ 
        CREATE TABLE IF NOT EXISTS drome_offline_rewards (
            player_id INT NOT NULL,
            rewards TEXT NOT NULL,
            PRIMARY KEY (player_id)
        );
    ]])
end

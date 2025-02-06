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

local leverAction = Action()
local deathEvent = CreatureEvent("DromeMonsterDeath")
local configDrome = {
    requiredLevel = 50,
    playerPositions = {
        { pos = Position(32253, 32199, 12), teleport = Position(32254, 32193, 12), effect = CONST_ME_MAGIC_BLUE },
        { pos = Position(32253, 32200, 12), teleport = Position(32254, 32193, 12), effect = CONST_ME_MAGIC_BLUE },
        { pos = Position(32253, 32201, 12), teleport = Position(32254, 32193, 12), effect = CONST_ME_MAGIC_BLUE },
        { pos = Position(32253, 32202, 12), teleport = Position(32254, 32193, 12), effect = CONST_ME_MAGIC_BLUE },
        { pos = Position(32253, 32203, 12), teleport = Position(32254, 32193, 12), effect = CONST_ME_MAGIC_BLUE },
    },
    specPos = {
        from = Position(32246, 32177, 12),
        to = Position(32264, 32195, 12),
    },
    exit = Position(32259, 32178, 12),
    timeToFightAgain = 14400,
}

local lastFightTime = 0
local dromeLevel = 0
local monstersKilled = 0
local playerWaveData = {}

local creaturePool = {
    "Domestikion",
    "Hoodinion",
    "Mearidion",
    "Murmillion",
    "Scissorion"
}
rangeX = math.abs(configDrome.specPos.to.x - configDrome.specPos.from.x)
rangeY = math.abs(configDrome.specPos.to.y - configDrome.specPos.from.y)


function deathEvent.onDeath(creature, corpse, killer, mostDamageKiller)
    if creature:isMonster() then
        monstersKilled = monstersKilled + 1
        checkWaveCompletion(killer)
    end
    return true
end

deathEvent:register()

function calculateMonsters(playerCount)
    local monstersPerPlayer = {
        [1] = 4,
        [2] = 8,
        [3] = 11,
        [4] = 14,
        [5] = 17
    }
    return monstersPerPlayer[playerCount] or 4
end

function spawnMonsters(playerCount)
    local monsterCount = calculateMonsters(playerCount)
    local baseHP = 1000
    local scaledHP = baseHP * (1.039 ^ dromeLevel)

    local spawnedCount = 0

    while spawnedCount < monsterCount do
        local spawnPos = Position(math.random(32246, 32264), math.random(32177, 32195), 12)
        local tile = Tile(spawnPos)
        if tile and tile:getGround() and not tile:hasProperty(CONST_PROP_BLOCKSOLID) then
            local creatureName = creaturePool[math.random(#creaturePool)]
            local monster = Game.createMonster(creatureName, spawnPos)
            if monster then
                monster:setMaxHealth(scaledHP)
                monster:setHealth(scaledHP)
                monster:registerEvent("DromeMonsterDeath")
                spawnPos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
                spawnedCount = spawnedCount + 1
            end
        end
    end
end

local waveTimer = nil
local waveTimeLimit = 120

function startWaveTimer()
    if waveTimer then
        stopEvent(waveTimer)
    end

    waveTimer = addEvent(function()
        local playerCount = countPlayersInArea()

        if playerCount > 0 then
            local centerPosition = Position(configDrome.specPos.from.x, configDrome.specPos.from.y, configDrome.specPos.from.z)
            local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

            if #spectators > 0 then
                for _, spectator in pairs(spectators) do
                    spectator:teleportTo(Position(32255, 32205, 11))
                    spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You failed to complete the wave in time! You have been kicked out.")
                end
            end
        end
    end, waveTimeLimit * 1000)
end

function checkWaveCompletion(player)
    local playerCount = countPlayersInArea()
    local requiredMonsters = calculateMonsters(playerCount)

    if monstersKilled >= requiredMonsters then
        if waveTimer then
            stopEvent(waveTimer)
        end

        local centerPosition = Position(configDrome.specPos.from.x, configDrome.specPos.from.y, configDrome.specPos.from.z)
        local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

        -- Check if there are any players in the area
        if #spectators > 0 then
            for _, targetPlayer in pairs(spectators) do
                local playerId = targetPlayer:getGuid()
                local playerName = targetPlayer:getName()
                local playerHighscore = playerWaveData[playerId] or 0

                playerWaveData[playerId] = playerHighscore + 1
                
                db.query(string.format([[ 
                    INSERT INTO drome_highscores (player_id, player_name, highscore) 
                    VALUES (%d, %s, %d) 
                    ON DUPLICATE KEY UPDATE 
                    highscore = GREATEST(highscore, %d), 
                    updated_at = NOW();
                ]], playerId, db.escapeString(playerName), playerWaveData[playerId], playerWaveData[playerId]))
            end
        end

        dromeLevel = dromeLevel + 1
        monstersKilled = 0

        local message = "Next wave will start in 8 seconds. Current level: " .. dromeLevel
        for _, targetPlayer in pairs(spectators) do
            targetPlayer:say(message, TALKTYPE_YELL)
        end

        addEvent(function()
            local playerCount = countPlayersInArea()
            if playerCount > 0 then
                spawnMonsters(playerCount)
            end
        end, 8000)

        storeWaveInItemAtPosition()
        storeLeaderboardInItemAtPosition()
        startWaveTimer()
    else
    end
end

local playerCooldowns = {}

function leverAction.onUse(player, item, fromPosition, target, isHotkey)
    if item:getActionId() == 46985 then
        local playerId = player:getGuid()
        local lastFightTime = playerCooldowns[playerId] or 0 
        local currentTime = os.time()

        if currentTime - lastFightTime < configDrome.timeToFightAgain then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait before entering the Tibiadrome again.")
            return true
        end

        local isInValidPosition = false
        for _, posData in ipairs(configDrome.playerPositions) do
            if player:getPosition() == posData.pos then
                isInValidPosition = true
                break
            end
        end

        if not isInValidPosition then
          --  player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must be in a valid position to use the lever.")
            return true
        end

        local isAnyoneInSpecPos = false
        local centerPosition = Position(configDrome.specPos.from.x, configDrome.specPos.from.y, configDrome.specPos.from.z)
        local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

        for _, targetPlayer in pairs(spectators) do
            if targetPlayer:getPosition():isInRange(configDrome.specPos.from, configDrome.specPos.to) then
                isAnyoneInSpecPos = true
                break
            end
        end

        if isAnyoneInSpecPos then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is already inside the Tibiadrome. Please wait until they leave.")
            return true
        end

        playerCooldowns[playerId] = currentTime

        local isAnyPlayerInPosition = false
        local playersToTeleport = {}

        for _, posData in ipairs(configDrome.playerPositions) do
            local centerPosition = Position(posData.pos.x, posData.pos.y, posData.pos.z)
            local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)
        
            for _, targetPlayer in pairs(spectators) do
                if targetPlayer:getPosition():isInRange(posData.pos, posData.pos) then
                    table.insert(playersToTeleport, targetPlayer)
                    isAnyPlayerInPosition = true
                    break
                end
            end
        end
        
        if not isAnyPlayerInPosition then
            return true
        end

        for _, targetPlayer in ipairs(playersToTeleport) do
            local playerId = targetPlayer:getGuid()
            local query = string.format("SELECT highscore FROM drome_highscores WHERE player_id = %d", playerId)
            local resultId = db.storeQuery(query)

            local playerHighscore = 0
            if resultId then
                playerHighscore = result.getNumber(resultId, "highscore") or 0
                result.free(resultId)
            end

            local startingWave = math.max(playerHighscore - 5, 0)
            playerWaveData[playerId] = startingWave
        end

        for _, targetPlayer in ipairs(playersToTeleport) do
            local entryPos = configDrome.playerPositions[math.random(#configDrome.playerPositions)].teleport
            targetPlayer:teleportTo(entryPos)
            targetPlayer:getPosition():sendMagicEffect(configDrome.playerPositions[math.random(#configDrome.playerPositions)].effect)
        end

        if waveTimer then
            stopEvent(waveTimer)
        end

        dromeLevel = 0
        spawnMonsters(countPlayersInArea())
        waveTimer = nil
        startWaveTimer()

        return true
    end
    return false
end


function countPlayersInArea()
    local playerCount = 0
    local centerPosition = Position(configDrome.specPos.from.x, configDrome.specPos.from.y, configDrome.specPos.from.z)
    local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)

    for _, targetPlayer in pairs(spectators) do
        playerCount = playerCount + 1
    end

    return playerCount
end

function removeMonstersFromArea()
    for x = configDrome.specPos.from.x, configDrome.specPos.to.x do
        for y = configDrome.specPos.from.y, configDrome.specPos.to.y do
            local position = Position(x, y, 12)
            local tile = Tile(position)
            
            if tile then
                for _, creature in pairs(tile:getCreatures()) do
                    if creature:isMonster() then
                        local monsterName = creature:getName()
                        local validMonsters = {
                            "Domestikion", "Hoodinion", "Mearidion", "Murmillion", "Scissorion"
                        }

                        for _, validMonster in ipairs(validMonsters) do
                            if monsterName == validMonster then
                                creature:remove()
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

function checkForMonstersRemoval()
    if countPlayersInArea() == 0 then
        removeMonstersFromArea()
        if waveTimer then
            stopEvent(waveTimer)
        end
        waveTimer = nil
        monstersKilled = 0 
        dromeLevel = 0 
    end
    addEvent(checkForMonstersRemoval, 1000)
end

checkForMonstersRemoval()

function storeLeaderboardInItemAtPosition()
    local itemPositions = {
        Position(32255, 32203, 11),
        Position(33378, 31820, 9),
        Position(33154, 32972, 8),
        Position(33537, 31820, 9),
        Position(32706, 31820, 12)
    }

    for _, itemPosition in ipairs(itemPositions) do
        local tile = Tile(itemPosition)

        if not tile then
            return
        end

        local item = tile:getItemById(36828)
        if not item then
            return
        end

        local query = "SELECT player_name, highscore FROM drome_highscores ORDER BY highscore DESC LIMIT 10"
        local resultId = db.storeQuery(query)

        if not resultId then
            item:setAttribute(ITEM_ATTRIBUTE_TEXT, "The current drome leaderboard:\nNo records found.")
            return
        end

        local leaderboardText = "The current drome leaderboard:\n"
        local rank = 1

        repeat
            local playerName = result.getString(resultId, "player_name")
            local highscore = result.getNumber(resultId, "highscore")
            leaderboardText = leaderboardText .. rank .. ". " .. playerName .. ": " .. highscore .. "\n"
            rank = rank + 1
        until not result.next(resultId)

        result.free(resultId)

        item:setAttribute(ITEM_ATTRIBUTE_TEXT, leaderboardText)
    end
end

function storeWaveInItemAtPosition()
    local itemPosition = Position(32251, 32196, 11)
    local tile = Tile(itemPosition)

    if not tile then
        return
    end

    local item = tile:getItemById(36870)
    if not item then
        return
    end

    local waveInfoText = "Current Wave: " .. dromeLevel
    item:setAttribute(ITEM_ATTRIBUTE_TEXT, waveInfoText)
end

leverAction:aid(46985)
leverAction:register()

function resetHighScores()
    local query = "SELECT last_reset FROM drome_reset WHERE id = 1"
    local resultId = db.storeQuery(query)

    local lastReset = 0
    if resultId then
        local lastResetString = result.getString(resultId, "last_reset") or ""
        result.free(resultId)

        if lastResetString ~= "" then
            lastReset = os.time{
                year = tonumber(lastResetString:sub(1, 4)),
                month = tonumber(lastResetString:sub(6, 7)),
                day = tonumber(lastResetString:sub(9, 10)),
                hour = tonumber(lastResetString:sub(12, 13)),
                min = tonumber(lastResetString:sub(15, 16)),
                sec = tonumber(lastResetString:sub(18, 19))
            }
        end
    end

    local currentTime = os.time()
    local resetInterval = 5 * 24 * 60 * 60

    if currentTime - lastReset >= resetInterval then
        local rewards = {
            {itemId = 36725, count = 1}, -- stamina
            {itemId = 36727, count = 1}, -- wealth duplex
            {itemId = 36742, count = 1}, -- physical amplification
            {itemId = 36735, count = 1}, -- physical resilience
            {itemId = 36737, count = 1}, -- ice amp
            {itemId = 36730, count = 1}, -- ice res
            {itemId = 36740, count = 1}, -- holy amp
            {itemId = 36733, count = 1}, -- holy res
            {itemId = 36736, count = 1}, -- fire amp
            {itemId = 36729, count = 1}, -- fire res
            {itemId = 36739, count = 1}, -- energy amp
            {itemId = 36732, count = 1}, -- energy res
            {itemId = 36738, count = 1}, -- earth amp
            {itemId = 36731, count = 1}, -- earth res
            {itemId = 36741, count = 1}, -- death amp
            {itemId = 36734, count = 1}  -- death res
        }

        local topPlayersQuery = "SELECT player_id, player_name FROM drome_highscores ORDER BY highscore DESC LIMIT 10"
        local topPlayersResult = db.storeQuery(topPlayersQuery)

        if topPlayersResult then
            repeat
                local playerId = result.getNumber(topPlayersResult, "player_id")
                local playerName = result.getString(topPlayersResult, "player_name")
                local player = Player(playerId)

                if player then
                    local inbox = player:getStoreInbox()
                    if inbox then
                        local randomReward = rewards[math.random(1, #rewards)]
                        inbox:addItem(randomReward.itemId, randomReward.count)
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations, " .. playerName .. "! You have received a reward for being in the top 10 of the Drome leaderboard!")
                    end
                else
                    local storedRewards = ""
                    local rewardCount = 0
                    local randomReward = rewards[math.random(1, #rewards)]
                    storedRewards = storedRewards .. randomReward.itemId .. ":" .. randomReward.count .. ","
                    db.query("INSERT INTO drome_offline_rewards (player_id, rewards) VALUES (" .. playerId .. ", '" .. storedRewards .. "') ON DUPLICATE KEY UPDATE rewards = '" .. storedRewards .. "'")
                end
            until not result.next(topPlayersResult)
            result.free(topPlayersResult)
        end

        db.query([[TRUNCATE TABLE drome_highscores]])
        db.query([[UPDATE drome_reset SET last_reset = NOW() WHERE id = 1]])

        for _, player in pairs(Game.getPlayers()) do
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The Drome high scores have been reset, and the top players have received their rewards!")
        end

        local itemPosition = Position(32255, 32203, 11)
        local tile = Tile(itemPosition)
        if tile then
            local item = tile:getItemById(36828)
            if item then
                item:setAttribute(ITEM_ATTRIBUTE_TEXT, "The current drome leaderboard:\nAll records have been cleared.")
            end
        end
        activateRandomMechanics()
    end
    addEvent(resetHighScores, resetInterval * 1000)
end

local offlinereward = CreatureEvent('RewardDrome')
function offlinereward.onLogin(player)
    if not player then
        return true
    end

    local playerId = player:getGuid()
    local query = "SELECT rewards FROM drome_offline_rewards WHERE player_id = " .. playerId .. " LIMIT 1"
    local resultId, err = db.storeQuery(query)
    if not resultId then
        return true
    end

    local rewardsString = result.getString(resultId, "rewards")
    result.free(resultId)

    if rewardsString and rewardsString ~= "" then
        local rewards = {}
        for reward in rewardsString:gmatch("([^,]+)") do
            local itemId, count = reward:match("(%d+):(%d+)")
            if itemId and count then
                table.insert(rewards, {itemId = tonumber(itemId), count = tonumber(count)})
            end
        end

        local inbox = player:getStoreInbox()
        if inbox then
            for _, reward in ipairs(rewards) do
                if not inbox:addItem(reward.itemId, reward.count) then
                else
                end
            end

            db.query("DELETE FROM drome_offline_rewards WHERE player_id = " .. playerId)
        else
        end
    else
    end

    return true
end

offlinereward:register()

-- save it to retrieve data for monsters and future development
function getDromeLevel(player)
    local playerId = player:getId()
    local dromeLevel = dromeLevel + 1
    local query = string.format("SELECT highscore FROM drome_highscores WHERE player_id = %d", playerId)
    local resultId = db.storeQuery(query)
    if resultId and result:getID() ~= -1 then
        dromeLevel = result:getNumber("highscore")
    end

    return dromeLevel
end

function onServerStart()
    local query = "SELECT COUNT(*) AS count FROM drome_reset"
    local resultId = db.storeQuery(query)

    if resultId and result.getNumber(resultId, "count") == 0 then
        db.query([[INSERT INTO drome_reset (last_reset) VALUES (NOW())]])
    end

    result.free(resultId)
    storeLeaderboardInItemAtPosition()
    addEvent(resetHighScores, 1000)
    activateRandomMechanics()
end

addEvent(onServerStart, 1)

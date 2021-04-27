bossConfig = {
        [34000] = {  -- ActionID
        requiredLevel = 150,
        minPlayersRequired = 1,

        boss = "Brokul",
        bossGlobalStorage = 35000,
        playerStorage = 36000,
        teleportPosition = Position(33483, 31445, 15),
        centerRoomPosition = Position(33483, 31439, 15),
        northRange = 15, eastRange = 15, southRange = 15, westRange = 15,
        exit = Position(33522, 31468, 15),
        bossPosition = Position(33483, 31434, 15),
        time = 15,

        playerPositions = {
            [1] = Position(33520, 31465, 15),
            [2] = Position(33521, 31465, 15),
            [3] = Position(33522, 31465, 15),
            [4] = Position(33523, 31465, 15),
            [5] = Position(33524, 31465, 15)
        }
    }
}

local function resetBoss(bossConfig, bossId)
    local monster = Monster(bossId)
    if monster then
        monster:remove()
    end
    local spectators = Game.getSpectators(bossConfig.centerRoomPosition, false, true, bossConfig.westRange, bossConfig.eastRange, bossConfig.northRange, bossConfig.southRange)
    for i = 1, #spectators do
        spectators[i]:teleportTo(bossConfig.exit)
    end
end

local secretBrokul = Action()
function secretBrokul.onUse(player, item, fromPosition, target, toPosition, isHotkey)
   
    if item.itemid == 1946 then
        local bossConfig = bossConfig[item:getActionId()]
        if not bossConfig then
            return false
        end
 
        if (getGlobalStorageValue(bossConfig.bossGlobalStorage) > 0) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There is already a team inside. Please wait.")
            return true
        end
 
        local errorMsg
        local rPlayers = {}
        for index, ipos in pairs(bossConfig.playerPositions) do
            local playerTile = Tile(ipos):getTopCreature()
            if playerTile then
                if playerTile:isPlayer() then
                    if playerTile:getLevel() >= bossConfig.requiredLevel then
                        if playerTile:getStorageValue(bossConfig.playerStorage) <= os.time() then
                            table.insert(rPlayers, playerTile:getId())
                        else
                            errorMsg = 'One or more players have already entered in the last 20 hours.'
                        end
                    else
                        errorMsg = 'All the players need to be level '.. bossConfig.requiredLevel ..' or higher.'
                    end
                end
            end
        end
 
        if (#rPlayers >= bossConfig.minPlayersRequired) then
            for _, pid in pairs(rPlayers) do
                local rplayer = Player(pid)
                if rplayer:isPlayer() then
                    rplayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, ('You have %o minutes before you get kicked out.'):format(bossConfig.time))
                    bossConfig.playerPositions[_]:sendMagicEffect(CONST_ME_POFF)
                    rplayer:teleportTo(bossConfig.teleportPosition)
                    rplayer:setStorageValue(bossConfig.playerStorage, os.time() + (20 * 60 * 60))
                    bossConfig.teleportPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
                    rplayer:setDirection(DIRECTION_NORTH)
                end
            end
            setGlobalStorageValue(bossConfig.bossGlobalStorage, 1)
            addEvent(setGlobalStorageValue, bossConfig.time * 60 * 1000, bossConfig.bossGlobalStorage, 0)
            local monster = Game.createMonster(bossConfig.boss, bossConfig.bossPosition)
            addEvent(resetBoss, bossConfig.time * 60 * 1000, bossConfig, monster and monster.uid or 0)
        else
            if not errorMsg then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, ("You need %u players."):format(bossConfig.minPlayersRequired))
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, errorMsg)
            end
            return true
        end
 
    end
    item:transform(item.itemid == 1946 and 1945 or 1946)
 
    return true
end

secretBrokul:aid(34000)
secretBrokul:register()
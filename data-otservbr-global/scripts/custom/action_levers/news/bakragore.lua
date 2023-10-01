local config = {
    actionId = 51037, 
    bossName = "Bakragore",
    servants = "Wandering Pillar",
    servantsTwo = "Elder Bloodjaw",
    servantsPosition = Position(31142, 32021, 9), 
    bossPosition = Position(31142, 32019, 9), 
    bossArea = {
        fromPos = Position(31122, 32004, 9), 
        toPos = Position(31162, 32037, 9), 
        entrancePos = Position(31143, 32030, 9), 
        exitPosition = Position(31348, 32078, 8) 
    },
    participantsAllowAnyCount = true, 
    participantsPos = {
        Position(31348, 32076, 8),
        Position(31347, 32077, 8),
        Position(31348, 32077, 8), 
        Position(31349, 32077, 8),
        Position(31347, 32078, 8), 
        Position(31348, 32078, 8),  
        Position(31349, 32078, 8),
        Position(31347, 32079, 8),
        Position(31348, 32079, 8),
        Position(31349, 32079, 8),  
    },
    attempts = {
        level = 200, 
        storage = 708230, 
        seconds = 3600 -- 1 h
    },
    createTeleportPos = Position(31138, 32019, 9), 
    teleportToPosition = Position(31348, 32078, 8), 
    fromPosition =  Position(31134, 32012, 9), 
    toPosition =  Position(31149, 32025, 9),
    teleportRemoveSeconds = 120, 
    kickParticipantAfterSeconds = 120 * 10,
    leverIds = {8911, 8912} 
}

local crystalIds = {15172, 15172} 
local crystalPositions = {
    Position(31138, 32019, 9),
    Position(31146, 32024, 9)
}
local crystalTimers = {}

local function getRandomCrystalPosition()
    local randomX = math.random(config.fromPosition.x, config.toPosition.x)
    local randomY = math.random(config.fromPosition.y, config.toPosition.y)
    local randomZ = math.random(config.fromPosition.z, config.toPosition.z)
    return Position(randomX, randomY, randomZ)
end

local function handleCrystals()
    for i = 1, #crystalIds do
        local crystalPosition = crystalPositions[i]
        local crystal = Tile(crystalPosition):getTopDownItem()
        if crystal and crystal:getId() == crystalIds[i] then
            crystal:remove(1)
        end
        local randomPos = getRandomCrystalPosition()
        crystalPositions[i] = randomPos
        Game.createItem(crystalIds[i], 1, randomPos)
    end
end

local function startCrystalTimers()
    for i = 1, #crystalIds do
        local timerDisappear = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getItemById(crystalIds[i])
            if crystal then
                crystal:remove()
            end
        end, 10000) 

        local timerRespawn = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getTopDownItem()
            if not crystal or crystal:getId() ~= crystalIds[i] then
                local randomPos = getRandomCrystalPosition()
                crystalPositions[i] = randomPos
                Game.createItem(crystalIds[i], 1, randomPos)
            end
        end, 20000) 

        local timerDisappearTwo = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getItemById(crystalIds[i])
            if crystal then
                crystal:remove()
            end
        end, 30000) 

        local timerRespawnTwo = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getTopDownItem()
            if not crystal or crystal:getId() ~= crystalIds[i] then
                local randomPos = getRandomCrystalPosition()
                crystalPositions[i] = randomPos
                Game.createItem(crystalIds[i], 1, randomPos)
                Game.createMonster(config.servants, config.servantsPosition)
                Game.createMonster(config.servants, config.servantsPosition)
            end
        end, 50000) 

        local timerDisappearThre = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getItemById(crystalIds[i])
            if crystal then
                crystal:remove()
            end
        end, 65000) 

        local timerRespawnThre = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getTopDownItem()
            if not crystal or crystal:getId() ~= crystalIds[i] then
                local randomPos = getRandomCrystalPosition()
                crystalPositions[i] = randomPos
                Game.createItem(crystalIds[i], 1, randomPos)
            end
        end, 75000) 

        local timerDisappearFour = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getItemById(crystalIds[i])
            if crystal then
                crystal:remove()
            end
        end, 85000) 

        local timerRespawnFour = addEvent(function()
            local crystal = Tile(crystalPositions[i]):getTopDownItem()
            if not crystal or crystal:getId() ~= crystalIds[i] then
                local randomPos = getRandomCrystalPosition()
                crystalPositions[i] = randomPos
                Game.createItem(crystalIds[i], 1, randomPos)
                Game.createMonster(config.servantsTwo, config.servantsPosition)
                Game.createMonster(config.servantsTwo, config.servantsPosition)
            end
        end, 100000) 


        table.insert(crystalTimers, timerDisappear)
        table.insert(crystalTimers, timerRespawn)
        table.insert(crystalTimers, timerDisappearTwo)
        table.insert(crystalTimers, timerRespawnTwo)
        table.insert(crystalTimers, timerDisappearThre)
        table.insert(crystalTimers, timerRespawnThre)
        table.insert(crystalTimers, timerDisappearFour)
        table.insert(crystalTimers, timerRespawnFour)
    end
end




local function getSpectators()
    if not config.centerPosition then
        config.diffX = math.ceil((config.bossArea.toPos.x - config.bossArea.fromPos.x) / 2)
        config.diffY = math.ceil((config.bossArea.toPos.y - config.bossArea.fromPos.y) / 2)
        config.centerPosition = config.bossArea.fromPos + Position(config.diffX, config.diffY, 0)
    end
    return Game.getSpectators(config.centerPosition, false, false, config.diffX, config.diffX, config.diffY, config.diffY)
end

local brainstealerLever = Action()

function brainstealerLever.onUse(player, item, fromPos, target, toPos, isHotkey)
    local participants = {}
    for index, pos in pairs(config.participantsPos) do
        local tile = Tile(pos)
        if not tile then error("[Warning - Tile not found]") end
        local participant = tile:getTopVisibleCreature(player)
        if participant and participant:isPlayer() then
            if index == 1 and participant ~= player then
                player:sendCancelMessage("Only the first participant can pull the lever.")
                return true
            end

            if participant:getStorageValue(config.attempts.storage) >= os.time() then
                player:sendCancelMessage(string.format("The player %s must wait 1 hour before being able to enter again.", participant:getName()))
                return true
            elseif participant:getLevel() < config.attempts.level then
                player:sendCancelMessage(string.format("The player %s is not level %d.", participant:getName(), config.attempts.level))
                return true
            end
            participants[#participants +1] = participant    
        end
    end

    local spectators = getSpectators()
    for _, spectator in pairs(spectators) do
        if spectator:isPlayer() then
            player:sendCancelMessage("At this time the room is occupied, please try again later.")
            return true
        end
    end

    for _, spectator in pairs(spectators) do spectator:remove() end
    local boss = Game.createMonster(config.bossName, config.bossPosition)
    if not boss then error(Game.getReturnMessage(RETURNVALUE_NOTENOUGHROOM)) end
    boss:registerEvent("bakragoreBoss")
    player:registerEvent("bakragoreBossCrystal") 
    for index, participant in pairs(participants) do
        config.participantsPos[index]:sendMagicEffect(CONST_ME_POFF)
        participant:teleportTo(config.bossArea.entrancePos, false)
        config.bossArea.entrancePos:sendMagicEffect(CONST_ME_TELEPORT)
        participant:setStorageValue(config.attempts.storage, os.time() + config.attempts.seconds)
        config.crystalTimerId = addEvent(function ()
            handleCrystals()
        end, 5000) 
        startCrystalTimers()
    end
    

    config.kickEventId = addEvent(function ()
        for _, spectator in pairs(getSpectators()) do
            if spectator:isPlayer() then
                spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                spectator:teleportTo(config.bossArea.exitPosition, false)
                config.bossArea.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
                spectator:sendTextMessage(MESSAGE_INFO_DESCR, "It's been a long time and you haven't managed to defeat Bakragore.")
            else
                spectator:remove()
            end
        end
    end, config.kickParticipantAfterSeconds * 1000)
    item:transform(item:getId() == config.leverIds[1] and config.leverIds[2] or config.leverIds[1])
    return true
end

brainstealerLever:aid(config.actionId)
brainstealerLever:register()




local brainstealerCrystalUsage = Action()

function brainstealerCrystalUsage.onUse(player, item, fromPos, target, toPos, isHotkey)
    if item:getId() == 31990 and target:getId() == 15172 then 
        local boss = nil
        local bossPosition = nil
        local range = 6
        
       
        for x = -range, range do
            for y = -range, range do
                for z = -range, range do
                    local tile = Tile(config.bossPosition.x + x, config.bossPosition.y + y, config.bossPosition.z + z)
                    if tile then
                        local creature = tile:getTopCreature()
                        if creature and creature:isMonster() and creature:getName() == config.bossName then
                            boss = creature
                            bossPosition = tile:getPosition()
                            break
                        end
                    end
                end
                if boss then
                    break
                end
            end
            if boss then
                break
            end
        end

        if boss then
            boss:addHealth(-10000) 
            player:sendTextMessage(MESSAGE_INFO_DESCR, "The boss has lost 10000 hitpoints.")
        end

        target:remove()
    end
    return true
end






brainstealerCrystalUsage:id(31990)
brainstealerCrystalUsage:register()

local creatureEvent = CreatureEvent("bakragoreBoss")

function creatureEvent.onDeath()
    stopEvent(config.kickEventId)
    stopEvent(config.crystalTimerId) -- Stop crystal timers
    local teleport = Game.createItem(1949, 1, config.createTeleportPos)
    if teleport then
        teleport:setDestination(config.teleportToPosition)
        addEvent(function ()
            local tile = Tile(config.createTeleportPos)
            if tile then
                local teleport = tile:getItemById(1949)
                if teleport then
                    teleport:remove()
                    config.teleportToPosition:sendMagicEffect(CONST_ME_POFF)
                end
            end

            for _, spectator in pairs(getSpectators()) do
                if spectator:isPlayer() then
                    spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                    spectator:teleportTo(config.teleportToPosition, false)
                    config.teleportToPosition:sendMagicEffect(CONST_ME_TELEPORT)
                end
            end
        end, config.teleportRemoveSeconds * 1000)
    end
    return true
end

creatureEvent:register()

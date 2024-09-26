local config = {
    actionId = 54504, 
    bossName = "Razorbrood",
    bossPosition = Position(32519, 32579, 7), 
    bossArea = {
        fromPos = Position(32509, 32576, 7), 
        toPos = Position(32527, 32592, 7), 
        entrancePos = Position(32518, 32589, 7), 
        exitPosition = Position(32512, 32590, 7)
    },
    participantsAllowAnyCount = true, 
    participantsPos = {
        Position(32516, 32600, 7),
        Position(32516, 32601, 7),
        Position(32516, 32602, 7),
        Position(32516, 32603, 7),
        Position(32516, 32604, 7)
    },
    attempts = {
        level = 100, 
        storage = 710020, 
        seconds = 1 --cooldown de la palanca
    },
    createTeleportPos = Position(32518, 32578, 7), 
    teleportToPosition = Position(32516, 32569, 7), 
    teleportRemoveSeconds = 0, -- tiempo para remove wl tp
    kickParticipantAfterSeconds = 900, -- tiempo para estar dentro de la room
    leverIds = {9110, 9111}  -- id de las palancas 
}

local function getSpectators()
    if not config.centerPosition then
        config.diffX = math.ceil((config.bossArea.toPos.x - config.bossArea.fromPos.x) / 2)
        config.diffY = math.ceil((config.bossArea.toPos.y - config.bossArea.fromPos.y) / 2)
        config.centerPosition = config.bossArea.fromPos + Position(config.diffX, config.diffY, 0)
    end
    return Game.getSpectators(config.centerPosition, false, false, config.diffX, config.diffX, config.diffY, config.diffY)
end

local razorbroodLever = Action()

function razorbroodLever.onUse(player, item, fromPos, target, toPos, isHotkey)
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
                player:sendCancelMessage(string.format("The player %s must wait 3 hour before being able to enter again.", participant:getName()))
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
    boss:registerEvent("razorbroodBossLever")
    for index, participant in pairs(participants) do
        config.participantsPos[index]:sendMagicEffect(CONST_ME_POFF)
        participant:teleportTo(config.bossArea.entrancePos, false)
        config.bossArea.entrancePos:sendMagicEffect(CONST_ME_TELEPORT)
        participant:setStorageValue(config.attempts.storage, os.time() + config.attempts.seconds)
    end

    config.kickEventId = addEvent(function ()
        for _, spectator in pairs(getSpectators()) do
            if spectator:isPlayer() then
                spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
                spectator:teleportTo(config.bossArea.exitPosition, false)
                config.bossArea.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
                player:sendCancelMessage("It's been a long time and you haven't managed to defeat The Boss")
            else
                spectator:remove()
            end
        end
    end, config.kickParticipantAfterSeconds * 1000)

    item:transform(item:getId() == config.leverIds[1] and config.leverIds[2] or config.leverIds[1])
    return true
end

razorbroodLever:aid(config.actionId)
razorbroodLever:register()

local creatureEvent = CreatureEvent("razorbroodBossLever")

function creatureEvent.onDeath()
    stopEvent(config.kickEventId)
    local teleport = Game.createItem(25047, 1, config.createTeleportPos)
    if teleport then
        teleport:setDestination(config.teleportToPosition)
        addEvent(function ()
            local tile = Tile(config.createTeleportPos)
            if tile then
                local teleport = tile:getItemById(25047)
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

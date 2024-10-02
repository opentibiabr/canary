local function createCreaturesAround(player, maxRadius, creatureName, creatureCount, creatureForge, boolForceCreate)
    local position = player:getPosition()
    local createdCount = 0
    local sendMessage = false
    local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(creatureForge, player)

    for radius = 1, maxRadius do
        if createdCount >= creatureCount then
            break
        end

        local minX = position.x - radius
        local maxX = position.x + radius
        local minY = position.y - radius
        local maxY = position.y + radius
        
        for dx = minX, maxX do
            for dy = minY, maxY do
                if (dx == minX or dx == maxX or dy == minY or dy == maxY) and createdCount < creatureCount then
                    local checkPosition = Position(dx, dy, position.z)
                    local tile = Tile(checkPosition)

                    if tile and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) then
                        local monster = Game.createMonster(creatureName, checkPosition, false, boolForceCreate)
                        if monster then
                            createdCount = createdCount + 1
                            monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
                            position:sendMagicEffect(CONST_ME_MAGIC_RED)

                            if creatureForge ~= nil and monster:isForgeable() then
                                local monsterType = monster:getType()
                                if canSetFiendish then
                                    SetFiendish(monsterType, position, player, monster)
                                end
                                if canSetInfluenced then
                                    SetInfluenced(monsterType, monster, player, influencedLevel)
                                end
                            else
                                sendMessage = true
                            end
                        end
                    end
                end
            end
        end
    end

    if sendMessage then
        player:sendCancelMessage("Only allowed monsters can be fiendish or influenced!")
    end

    logger.info("Player {} created '{}' monsters", player:getName(), createdCount)
end

local createMonster = TalkAction("/m")
-- @function createMonster.onSay
-- @desc TalkAction to create monsters with multiple options.
-- @param player: The player executing the command.
-- @param words: Command words.
-- @param param: String containing the command parameters.
-- Format: "/m monstername, monstercount, [fiendish/influenced level], [forceCreate]"
-- Example: "/m rat, 10, fiendish"
-- @param: the last param is by default "false", if add "," or any value it's set to true
-- @return true if the command is executed successfully, false otherwise.
function createMonster.onSay(player, words, param)
    -- create Log of the command usage.
    logCommand(player, words, param)

    -- Check if parameters were passed.
    if param == "" then
        player:sendCancelMessage("Monster name param required.")
        logger.error("[createMonster.onSay] - Monster name param not found.")
        return true
    end

    local position = player:getPosition()
    local split = param:split(",")
    local monsterName = split[1]:trimSpace()
    
    local monsterType = MonsterType(monsterName)
    if not monsterType then
        player:sendCancelMessage("Invalid monster name!")
        return true
    end

    local monsterCount = tonumber(split[2]) or 1
    if monsterCount < 1 or monsterCount > 100 then
        if monsterCount > 100 then
            monsterCount = 100
            player:sendCancelMessage("You can only create up to 100 monsters at a time due to server stability concerns!")
            return false
        end
    end

    local monsterForge = split[3] and split[3]:trimSpace() or nil
    local influencedLevel = tonumber(split[3]) or 0

    if influencedLevel < 0 or influencedLevel > 5 then
        player:sendCancelMessage("Influenced level must be between 0 and 5.")
        return true
    end

    local spawnRadius = tonumber(split[4]) or 5
    local forceCreate = split[5] and split[5]:lower() == "true"

    if monsterCount > 1 then
        createCreaturesAround(player, spawnRadius, monsterName, monsterCount, monsterForge, forceCreate)
    else
        local monster = Game.createMonster(monsterName, position)
        if monster then
            local canSetFiendish, canSetInfluenced, influencedLevel = CheckDustLevel(monsterForge, player)
            monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            position:sendMagicEffect(CONST_ME_MAGIC_RED)
            if monsterForge and not monster:isForgeable() then
                player:sendCancelMessage("Only allowed monsters can be fiendish or influenced!")
                return true
            end

            local monsterType = monster:getType()
            if canSetFiendish then
                SetFiendish(monsterType, position, player, monster)
            end
            if canSetInfluenced then
                SetInfluenced(monsterType, monster, player, influencedLevel)
            end
        else
            player:sendCancelMessage("There is not enough room.")
            position:sendMagicEffect(CONST_ME_POFF)
        end
    end

    return true
end

createMonster:separator(" ")
createMonster:groupType("god")
createMonster:register()

-- Command to rename monsters within a radius
-- @function setMonsterName.onSay
-- @desc TalkAction to rename nearby monsters within a radius of 4 sqms.
-- Format: "/setmonstername newName"
local setMonsterName = TalkAction("/setmonstername")

function setMonsterName.onSay(player, words, param)
    if param == "" then
        player:sendCancelMessage("Command param required.")
        return true
    end

    local newName = param:trimSpace()
    local position = player:getPosition()

    local spectators = Game.getSpectators(position, false, false, 4, 4, 4, 4)

    for _, spectator in ipairs(spectators) do
        if spectator:isMonster() then
            spectator:setName(newName)
        end
    end

    return true
end

setMonsterName:separator(" ")
setMonsterName:groupType("god")
setMonsterName:register()

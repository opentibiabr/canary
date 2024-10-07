local config = {
    boss = {
        name = "The Enraged Thorn Knight",
        createFunction = function()
            return Game.createMonster("Mounted Thorn Knight", Position(32624, 32880, 14), true, true)
        end,
    },
    requiredLevel = 250,
    timeToDefeat = 15 * 60,
    playerPositions = {
		{ pos = Position(32657, 32877, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32878, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32879, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32880, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32657, 32881, 14), teleport = Position(32624, 32886, 14), effect = CONST_ME_TELEPORT },
	},
    specPos = {
        from = Position(32613, 32869, 14),
        to = Position(32636, 32892, 14),
    },
    exit = Position(32678, 32888, 14),
    onUseExtra = function(player)
        for d = 1, 6 do
            Game.createMonster("possessed tree", Position(math.random(32619, 32629), math.random(32877, 32884), 14), true, true)
        end
    end
}

local leverThornKnight = Action()

function leverThornKnight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local players = {}
    local spectators = Game.getSpectators(config.specPos.from, false, false, 0, 0, 0, 0, config.specPos.to)

    for i = 1, #config.playerPositions do
        local pos = config.playerPositions[i].pos
        local creature = Tile(pos):getTopCreature()

        if not creature or not creature:isPlayer() then
            player:sendCancelMessage("You need " .. #config.playerPositions .. " players to challenge " .. config.boss.name .. ".")
            return true
        end

        local cooldownTime = creature:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.ThornKnightKilled)
        if cooldownTime > os.time() then
            local remainingTime = cooldownTime - os.time()
            local hours = math.floor(remainingTime / 3600)
            local minutes = math.floor((remainingTime % 3600) / 60)
            player:sendCancelMessage(creature:getName() .. " must wait " .. hours .. " hours and " .. minutes .. " minutes to challenge again.")
            return true
        end

        if creature:getLevel() < config.requiredLevel then
            player:sendCancelMessage(creature:getName() .. " needs to be at least level " .. config.requiredLevel .. " to challenge " .. config.boss.name .. ".")
            return true
        end

        table.insert(players, creature)
    end

    for _, spec in pairs(spectators) do
        if spec:isPlayer() then
            player:say("Someone is already inside the room.", TALKTYPE_MONSTER_SAY)
            return true
        end
    end

    if isBossInRoom(config.specPos.from, config.specPos.to, config.boss.name) then
        player:say("The room is being cleared. Please wait a moment.", TALKTYPE_MONSTER_SAY)
        return true
    end

    for i = 1, #players do
        local playerToTeleport = players[i]
        local teleportPos = config.playerPositions[i].teleport
        local effect = config.playerPositions[i].effect
        playerToTeleport:teleportTo(teleportPos)
        teleportPos:sendMagicEffect(effect)
    end

    config.boss.createFunction()

    config.onUseExtra(player)

    addEvent(clearBossRoom, config.timeToDefeat * 1000, config.specPos.from, config.specPos.to, config.exit)

    if item.itemid == 8911 then
        item:transform(8912)
    else
        item:transform(8911)
    end

    return true
end

function clearBossRoom(fromPos, toPos, exitPos)
    local spectators = Game.getSpectators(fromPos, false, false, 0, 0, 0, 0, toPos)
    for _, spec in pairs(spectators) do
        if spec:isPlayer() then
            spec:teleportTo(exitPos)
            exitPos:sendMagicEffect(CONST_ME_TELEPORT)
            spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You took too long, the battle has ended.")
        else
            spec:remove()
        end
    end
end

function isBossInRoom(fromPos, toPos, bossName)
    local monstersRemoved = false
    for x = fromPos.x, toPos.x do
        for y = fromPos.y, toPos.y do
            for z = fromPos.z, toPos.z do
                local tile = Tile(Position(x, y, z))
                if tile then
                    local creature = tile:getTopCreature()
                    if creature and creature:isMonster() then
                        creature:remove()
                        monstersRemoved = true
                    end
                end
            end
        end
    end
    return monstersRemoved
end

leverThornKnight:position(Position(32657, 32876, 14))
leverThornKnight:register()

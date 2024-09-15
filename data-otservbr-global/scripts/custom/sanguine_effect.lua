--[[
    Sanguine Effect
    Made by EnaraOT
]]--

local simpleAura = {
    talkAction = "!sanguine",
    distanceEffect = CONST_ME_AGONY,
    --vipStorage = 90003,
    autoStartOnLogin = true,
    onlyWhenEquippedItems = {
        [CONST_SLOT_LEFT] = 43886,
        [CONST_SLOT_LEFT] = 43871,
        [CONST_SLOT_LEFT] = 43865,
        [CONST_SLOT_LEFT] = 43883,
        [CONST_SLOT_LEFT] = 43867,
        [CONST_SLOT_LEFT] = 43873,
        [CONST_SLOT_LEFT] = 43878,
        [CONST_SLOT_LEFT] = 43880,
        [CONST_SLOT_LEFT] = 43875,
        [CONST_SLOT_LEFT] = 43869
    },
    auxTable = {} -- don't touch this
}

local directions = {
    DIRECTION_NORTH,
    DIRECTION_NORTHEAST,
    DIRECTION_EAST,
    DIRECTION_SOUTHEAST,
    DIRECTION_SOUTH,
    DIRECTION_SOUTHWEST,
    DIRECTION_WEST,
    DIRECTION_NORTHWEST,
    DIRECTION_NORTH
}

function simpleAura.checkItems(player)
    for slotIndex, itemId in pairs(simpleAura.onlyWhenEquippedItems) do
        local slotItem = player:getSlotItem(slotIndex)
        if not slotItem or slotItem:getId() ~= itemId then
            return false
        end
    end
    return true
end

if next(simpleAura.onlyWhenEquippedItems) then

    ec = EventCallback("SanguineEffects")
    function ec.playerOnItemMoved(player, item, count, fromPos, toPos, fromCylinder, toCylinder)
        if not player then
            return false
        end

        local containerPos = toPos.x == CONTAINER_POSITION and toPos or fromPos
        if containerPos.x == CONTAINER_POSITION then
            local slotIndex = simpleAura.onlyWhenEquippedItems[containerPos.y]
            if slotIndex then
                if simpleAura.checkItems(player) then
                    simpleAura.init(player)
                else
                    simpleAura.stop(player)
                end
            else
                simpleAura.stop(player)
            end
        end
    end
    ec:register()
end

function simpleAura.init(player)
    local playerId = player:getId()
    if not simpleAura.auxTable[playerId] then
        simpleAura.auxTable[playerId] = {}
    end

    local lastDirection = nil
    local auxTable = simpleAura.auxTable[playerId]
    for index, direction in pairs(directions) do
        auxTable[index] = addEvent(simpleAura.iterate, 125 * (index - 1), playerId, direction, lastDirection, index)
        lastDirection = direction
    end
end

function simpleAura.iterate(playerId, direction, lastDirection, index)
    local player = Player(playerId)
    if not player then
        return false
    end

    if lastDirection then
        local lastPos = player:getPosition()
        lastPos:getNextPosition(lastDirection)
        local pos = player:getPosition()
        pos:getNextPosition(direction)
        lastPos:sendMagicEffect(simpleAura.distanceEffect)
        --lastPos:sendDistanceEffect(pos, simpleAura.distanceEffect)
    end

    if index == 9 then
        simpleAura.init(player)
    end
end

function simpleAura.stop(player)
    local playerId = player:getId()
    local auxTable = simpleAura.auxTable[playerId]
    if auxTable then
        for _, eventId in pairs(auxTable) do
            stopEvent(eventId)
        end
        simpleAura.auxTable[playerId] = nil
    end
    return true
end

local talkAction = TalkAction(simpleAura.talkAction)

function talkAction.onSay(player, words, param, type)
    if simpleAura.checkItems(player) then
        local auxTable = simpleAura.auxTable[player:getId()] or {}
        if #auxTable ~= 0 then
            simpleAura.stop(player)
            player:sendCancelMessage("Sanguine Effect: Deactivated.")
            return true
        end
        simpleAura.init(player)
        player:sendCancelMessage("Sanguine Effect: Activated.")
    end

    return true
end

talkAction:groupType("normal")
talkAction:register()

if simpleAura.autoStartOnLogin then
    local creatureEvent = CreatureEvent("AuraOnLogin")
    function creatureEvent.onLogin(player)
        if simpleAura.checkItems(player) then
            simpleAura.init(player)
        end
        return true
    end

    creatureEvent:register()
    local creatureEvent = CreatureEvent("AuraOnLogout")
    creatureEvent.onLogout = simpleAura.stop
    creatureEvent:register()
end
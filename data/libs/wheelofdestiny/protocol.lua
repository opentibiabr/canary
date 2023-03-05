WheelOfDestinySystem.getWheelOfDestinyUsableEnum = function(player, owner)
    -- 0: Cannot change points.
    -- 1: Can increase and decrease points.
    -- 2: Can increase points but cannot decrease id.
    if not(WheelOfDestinySystem.config.enabled) then
        return 0
    end

    if not(player) then
        print("[WheelOfDestinySystem.sendWheelOfDestinyData]", "'player' cannot be null")
        return 0
    end

    if not(owner) then
        print("[WheelOfDestinySystem.sendWheelOfDestinyData]", "'owner' cannot be null")
        return 0
    end

    -- To-Do:
    if (player:getGuid() ~= owner:getGuid()) then
        return 0
    end

    if (player:getZone() == ZONE_PROTECTION) then
        local towns = Game.getTowns()
        for _, town in ipairs(towns) do
            if (player:getPosition():getDistance(town:getTemplePosition()) < 10) then
                return 1
            end
        end
    end

    return 2
end

WheelOfDestinySystem.parsePacket = function(player, msg, byte)
    if not(player) then
        print("[WheelOfDestinySystem.parsePacket]", "'player' cannot be null")
        return false
    end

    if (byte == WheelOfDestinySystem.enum.bytes.client.PROTOCOL_OPEN_WINDOW) then
        local owner = Player(msg:getU32())
        if not(owner) then
            owner = player
        end
        WheelOfDestinySystem.sendWheelOfDestinyData(player, owner)
        return true
    elseif (byte == WheelOfDestinySystem.enum.bytes.client.PROTOCOL_SAVE_WINDOW) then
        -- Clean old data
        WheelOfDestinySystem.resetPlayerBonusData(player)

        local sortedTable = {}
        for i = WheelOfDestinySystem.enum.slots.SLOT_FIRST, WheelOfDestinySystem.enum.slots.SLOT_LAST do
            local slotPoints = msg:getU16()
            if (slotPoints > WheelOfDestinySystem.getMaxPointsPerSlot(i)) then
                player:sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again")
                print("[WheelOfDestinySystem.parsePacket]", "Player '" .. player:getName() .. "' manipulated a client package using unauthorized program or the system is outdated with the client version")
                return true
            end
            table.insert(sortedTable, {order = WheelOfDestinySystem.getSlotPrioritaryOrder(i), slot = i, points = slotPoints})
        end

        local function compare(a, b)
            return a.order < b.order
        end

        local errors = 0
        local sortedTableRetry = {}
        table.sort(sortedTable, compare)
        for _, data in ipairs(sortedTable) do
            local rt = WheelOfDestinySystem.setSlotPoints(player, data.slot, data.points)
            if not(rt) then
                table.insert(sortedTableRetry, data)
                errors = errors + 1
            end
        end

        -- This error loop is to handle the Cipsoft weirdo tree
        if (#sortedTableRetry > 0) then
            local maxLoop = 5 -- Dont need to be higher then 5
            while (maxLoop > 0) do
                maxLoop = maxLoop - 1
                local temporaryTable = {}
                for _, data in ipairs(sortedTableRetry) do
                    local rt = WheelOfDestinySystem.setSlotPoints(player, data.slot, data.points)
                    if (rt) then
                        errors = errors - 1
                    else
                        table.insert(temporaryTable, data)
                    end
                end
                sortedTableRetry = temporaryTable
            end
        end

        if (#sortedTableRetry > 0) then
            player:sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again")
            print("[WheelOfDestinySystem.parsePacket]", "Player '" .. player:getName() .. "' tried to select a slot without the valid requirements")
            return true
        end

        -- Load bonus data
        WheelOfDestinySystem.loadPlayerBonusData(player)

        -- Save data on database
        WheelOfDestinySystem.savePlayerAllSlotsData(player)

        -- Register player bonus data
        WheelOfDestinySystem.registerPlayerBonusData(player)
        return true
    end
end

WheelOfDestinySystem.sendWheelOfDestinyData = function(player, owner)
    if not(player) then
        print("[WheelOfDestinySystem.sendWheelOfDestinyData]", "'player' cannot be null")
        return false
    end

    if not(WheelOfDestinySystem.config.enabled) then
        return true
    end

    if not(player) then
        print("[WheelOfDestinySystem.sendWheelOfDestinyData]", "'player' cannot be null")
        return false
    end

    if not(owner) then
        print("[WheelOfDestinySystem.sendWheelOfDestinyData]", "'owner' cannot be null")
        return false
    end

    local data = WheelOfDestinySystem.data.player[owner:getGuid()]
    if (data == nil) then
        print("[WheelOfDestinySystem.sendWheelOfDestinyData]", "owner 'data' cannot be null")
        return false
    end

    local canUse = WheelOfDestinySystem.canUseOwnWheel(owner)
    local vocation = WheelOfDestinySystem.getPlayerVocationEnum(owner)
    if (vocation == WheelOfDestinySystem.enum.vocation.VOCATION_INVALID) then
        canUse = false
    end

    if (player:getClient().version < 1310) then
        return true
    end

    local msg = NetworkMessage()
	msg:addByte(0x5F)
    msg:addU32(owner:getId())
    msg:addByte(canUse and 1 or 0)
    if not(canUse) then
        msg:sendToPlayer(player)
        return true
    end

    msg:addByte(WheelOfDestinySystem.getWheelOfDestinyUsableEnum(player, owner))
    msg:addByte(vocation)
    msg:addU16(WheelOfDestinySystem.getPoints(owner))
    for i = WheelOfDestinySystem.enum.slots.SLOT_FIRST, WheelOfDestinySystem.enum.slots.SLOT_LAST do
        msg:addU16(WheelOfDestinySystem.getPlayerPointsOnSlot(owner, i))
    end

    msg:sendToPlayer(player)
    return true
end

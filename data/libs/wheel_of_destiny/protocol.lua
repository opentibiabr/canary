Wheel.getWheelOfDestinyUsableEnum = function(player, owner)
	-- 0: Cannot change points.
	-- 1: Can increase and decrease points.
	-- 2: Can increase points but cannot decrease id.
	if not Wheel.enabled then
		return 0
	end

	if not player then
		Spdlog.error("[Wheel.sendWheelOfDestinyData] 'player' cannot be null")
		return 0
	end

	if not owner then
		Spdlog.error("[Wheel.sendWheelOfDestinyData] 'owner' cannot be null")
		return 0
	end

	-- To-Do:
	if player:getGuid() ~= owner:getGuid() then
		return 0
	end

	if player:getZone() == ZONE_PROTECTION then
		local towns = Game.getTowns()
		for _, town in ipairs(towns) do
			if player:getPosition():getDistance(town:getTemplePosition()) < 10 then
				return 1
			end
		end
	end

	return 2
end

Wheel.parsePacket = function(player, msg, byte)
	if not player then
		Spdlog.error("[Wheel.parsePacket] player is null")
		return false
	end

	if byte == Wheel.enum.bytes.client.PROTOCOL_OPEN_WINDOW then
		local ownerId = msg:getU32()
		if ownerId ~= player:getId() then
			Spdlog.error("[Wheel.parsePacket] playerId is invalid")
			return false
		end

		local owner = Player(ownerId)
		if not owner then
			Spdlog.error("[Wheel.parsePacket] owner is wrong")
			return false
		end

		Wheel.sendWheelOfDestinyData(player, owner)
		return true
	elseif byte == Wheel.enum.bytes.client.PROTOCOL_SAVE_WINDOW then
		-- Clean old data
		Wheel.resetPlayerBonusData(player)

		local sortedTable = {}
		for i = Wheel.enum.slots.SLOT_FIRST, Wheel.enum.slots.SLOT_LAST do
			local slotPoints = msg:getU16()
			if slotPoints > Wheel.getMaxPointsPerSlot(i) then
				player:sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again")
				Spdlog.error("[Wheel.parsePacket] Player '" .. player:getName() .. "' manipulated a client package using unauthorized program or the system is outdated with the client version")
				return true
			end
			table.insert(sortedTable, {order = Wheel.getSlotPrioritaryOrder(i), slot = i, points = slotPoints})
		end

		local function compare(a, b)
			return a.order < b.order
		end

		local errors = 0
		local sortedTableRetry = {}
		table.sort(sortedTable, compare)
		for _, data in ipairs(sortedTable) do
			local rt = Wheel.setSlotPoints(player, data.slot, data.points)
			if not rt then
				table.insert(sortedTableRetry, data)
				errors = errors + 1
			end
		end

		-- This error loop is to handle the Cipsoft weirdo tree
		if #sortedTableRetry > 0 then
			local maxLoop = 5 -- Dont need to be higher then 5
			while maxLoop > 0 do
				maxLoop = maxLoop - 1
				local temporaryTable = {}
				for _, data in ipairs(sortedTableRetry) do
					local rt = Wheel.setSlotPoints(player, data.slot, data.points)
					if rt then
						errors = errors - 1
					else
						table.insert(temporaryTable, data)
					end
				end
				sortedTableRetry = temporaryTable
			end
		end

		if #sortedTableRetry > 0 then
			player:sendTextMessage(MESSAGE_TRADE, "Something went wrong, try relogging and try again")
			Spdlog.error("[Wheel.parsePacket] Player '" .. player:getName() .. "' tried to select a slot without the valid requirements")
			return true
		end

		-- Load bonus data
		Wheel.loadPlayerBonusData(player)

		-- Save data on database
		Wheel.savePlayerAllSlotsData(player)

		-- Register player bonus data
		Wheel.registerPlayerBonusData(player)
		return true
	end
end

Wheel.sendWheelOfDestinyData = function(player, owner)
	if not Wheel.enabled then
		return true
	end

	if not player then
		Spdlog.error("[Wheel.sendWheelOfDestinyData] 'player' cannot be null")
		return false
	end

	if not player then
		Spdlog.error("[Wheel.sendWheelOfDestinyData] 'player' cannot be null")
		return false
	end

	if not owner then
		Spdlog.error("[Wheel.sendWheelOfDestinyData] 'owner' cannot be null")
		return false
	end

	local data = Wheel.data.player[owner:getGuid()]
	if data == nil then
		Spdlog.error("[Wheel.sendWheelOfDestinyData] owner 'data' cannot be null")
		return false
	end

	local canUse = Wheel.canUseOwnWheel(owner)
	local vocation = Wheel.getPlayerVocationEnum(owner)
	if vocation == VOCATION_NONE then
		canUse = false
	end

	if player:getClient().version < 1310 then
		return true
	end

	local msg = NetworkMessage()
	msg:addByte(0x5F)
	msg:addU32(owner:getId())
	msg:addByte(canUse and 1 or 0)
	if not canUse then
		msg:sendToPlayer(player)
		return true
	end

	msg:addByte(Wheel.getWheelOfDestinyUsableEnum(player, owner))
	msg:addByte(vocation)
	msg:addU16(Wheel.getPoints(owner))
	for i = Wheel.enum.slots.SLOT_FIRST, Wheel.enum.slots.SLOT_LAST do
		msg:addU16(Wheel.getPlayerPointsOnSlot(owner, i))
	end

	msg:sendToPlayer(player)
	return true
end

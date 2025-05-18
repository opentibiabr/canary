local positions = {
	-- Rebel
	{ x = 33136, y = 31248, z = 6 },
	{ x = 33211, y = 31067, z = 9 },
	-- Zlak
	{ x = 33216, y = 31067, z = 9 },
	{ x = 33076, y = 31218, z = 8 },
	{ x = 33076, y = 31219, z = 8 },
	-- Zizzle
	{ x = 33084, y = 31213, z = 8 },
	{ x = 33092, y = 31122, z = 12 },
	-- SleepingDragon
	{ x = 33111, y = 31123, z = 12 },
	{ x = 33240, y = 31249, z = 10 },
	-- awarnessEmperor
	{ x = 33360, y = 31395, z = 9 },
	{ x = 33072, y = 31150, z = 15 },
	{ x = 33365, y = 31415, z = 10 },
	-- bossRoom
	{ x = 33359, y = 31395, z = 9 },
	{ x = 33136, y = 31249, z = 6 },
	-- innerSanctum
	{ x = 33236, y = 31220, z = 10 },
	{ x = 33237, y = 31220, z = 10 },
	{ x = 33238, y = 31220, z = 10 },
	{ x = 33239, y = 31220, z = 10 },
	{ x = 33240, y = 31220, z = 10 },
	{ x = 33241, y = 31220, z = 10 },
	{ x = 33242, y = 31220, z = 10 },
	{ x = 33028, y = 31084, z = 13 },
}

local config = {
	{ Access = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Rebel, teleportPos = Position(33136, 31248, 6), destinationA = Position(33211, 31065, 9), destinationB = Position(33138, 31248, 6) },
	{ Access = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Zlak, teleportPos = Position(33216, 31067, 9), destinationA = Position(33078, 31219, 8), destinationB = Position(33216, 31069, 9) },
	{ Access = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Zizzle, teleportPos = Position(33084, 31213, 8), destinationA = Position(33094, 31122, 12), destinationB = Position(33083, 31214, 8), itemPos = Position(33086, 31214, 8) },
	{ Access = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.SleepingDragon, teleportPos = Position(33111, 31123, 12), destinationA = Position(33240, 31247, 10), destinationB = Position(33109, 31122, 12), destinationC = Position(33028, 31086, 13) },
	{ Access = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.AwarnessEmperor, teleportPos = Position(33072, 31150, 15), destinationA = Position(33361, 31397, 9), destinationB = Position(33071, 31152, 15) },
	{ Access = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.BossRoom, teleportPos = Position(33136, 31249, 6), destinationA = Position(33360, 31397, 9), destinationB = Position(33138, 31249, 6) },
	{ Access = Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.InnerSanctum, teleportPos = Position(33028, 31084, 13), destinationA = Position(33109, 31122, 12), destinationB = Position(33028, 31086, 13) },
}

local function tpX(i, player, position)
	if player:getStorageValue(config[i].Access) == 1 then
		if position == config[i].teleportPos then
			return config[i].destinationA
		else
			return config[i].destinationB
		end
	elseif player:getStorageValue(config[i].Access) == 2 then
		if position == config[i].teleportPos then
			return config[i].destinationC
		else
			return config[i].destinationB
		end
	elseif player:getStorageValue(config[i].Access) == 3 then
		if position == config[i].teleportPos then
			if Tile(config[i].itemPos):getItemById(11673) then
				config[i].itemPos:removeItem(11673, 1)
				return config[i].destinationA
			else
				player:say("This teleporter constantly flickers. It seems to be instable and completely unworking.", TALKTYPE_MONSTER_SAY)
				return false
			end
		else
			return config[i].destinationB
		end
	end
	return false
end

local function getDestinationByPos(player, position)
	local pos
	for j = 1, #positions do
		if j <= 2 then
			if position == Position(positions[j]) then
				pos = tpX(1, player, position)
			end
		elseif j > 2 and j <= 5 then
			if position == Position(positions[j]) then
				pos = tpX(2, player, position)
			end
		elseif j > 5 and j <= 7 then
			if position == Position(positions[j]) then
				pos = tpX(3, player, position)
			end
		elseif j > 7 and j <= 9 then
			if position == Position(positions[j]) then
				pos = tpX(4, player, position)
			end
		elseif j > 9 and j <= 12 then
			if position == Position(positions[j]) then
				pos = tpX(5, player, position)
			end
		elseif j > 12 and j <= 14 then
			if position == Position(positions[j]) then
				pos = tpX(6, player, position)
			end
		elseif j > 14 and j <= 22 then
			if position == Position(positions[j]) then
				pos = tpX(7, player, position)
			end
		end
	end
	return pos
end

local teleport = MoveEvent()
function teleport.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	local pos = getDestinationByPos(creature, position)
	if pos then
		creature:teleportTo(pos)
		pos:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	creature:teleportTo(fromPosition, true)
	fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

for index, value in pairs(positions) do
	teleport:position(value)
end
teleport:register()

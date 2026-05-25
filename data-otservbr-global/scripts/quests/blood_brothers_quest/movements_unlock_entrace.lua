local STORAGE_MISSION05 = Storage.Quest.U8_4.BloodBrothers.Mission05
local STORAGE_CASTLE_ENTRANCE = Storage.Quest.U8_4.BloodBrothers.CastleEntranceSTG

local symbols = {
	Position(32928, 31460, 7),
	Position(32941, 31510, 7),
	Position(32966, 31498, 6),
	Position(32946, 31499, 6),
}

local destinations = {
	Position(32951, 31479, 6),
	Position(32954, 31479, 6),
	Position(32951, 31482, 6),
	Position(32954, 31482, 6),
}

local function getPlayersOnSymbols()
	local found = {}
	for _, pos in ipairs(symbols) do
		local tile = Tile(pos)
		if not tile then
			return nil
		end
		local creature = tile:getTopCreature()
		if not creature or not creature:isPlayer() then
			return nil
		end
		local player = Player(creature)
		if player:getStorageValue(STORAGE_MISSION05) < 3 then
			return nil
		end

		if player:getStorageValue(STORAGE_CASTLE_ENTRANCE) ~= 1 then
			found[#found + 1] = player
		end
	end
	return found
end

local function getSymbolIndex(position)
	for i, pos in ipairs(symbols) do
		if pos.x == position.x and pos.y == position.y and pos.z == position.z then
			return i
		end
	end
	return nil
end

local crystalSymbols = MoveEvent()

function crystalSymbols.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	local player = Player(creature)
	if player:getStorageValue(STORAGE_MISSION05) < 3 then
		return true
	end

	local symbolIndex = getSymbolIndex(position)
	if not symbolIndex then
		return true
	end

	local tile1 = Tile(symbols[1])
	local tile2 = Tile(symbols[2])
	local tile3 = Tile(symbols[3])
	local tile4 = Tile(symbols[4])

	if not tile1 or not tile2 or not tile3 or not tile4 then
		return true
	end

	local c1 = tile1:getTopCreature()
	local c2 = tile2:getTopCreature()
	local c3 = tile3:getTopCreature()
	local c4 = tile4:getTopCreature()

	if not c1 or not c1:isPlayer() then
		return true
	end
	if not c2 or not c2:isPlayer() then
		return true
	end
	if not c3 or not c3:isPlayer() then
		return true
	end
	if not c4 or not c4:isPlayer() then
		return true
	end

	local players = { Player(c1), Player(c2), Player(c3), Player(c4) }

	for _, p in ipairs(players) do
		if p:getStorageValue(STORAGE_MISSION05) < 3 then
			return true
		end

		if p:getStorageValue(STORAGE_CASTLE_ENTRANCE) ~= 1 and p:getItemCount(8225) < 1 then
			return true
		end
	end

	for i, p in ipairs(players) do
		if p:getStorageValue(STORAGE_CASTLE_ENTRANCE) ~= 1 then
			p:setStorageValue(STORAGE_CASTLE_ENTRANCE, 1)
			p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Vengoth castle beckons to you... Report back to Julius.")
		end
		p:teleportTo(destinations[i])
		destinations[i]:sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

for _, pos in ipairs(symbols) do
	crystalSymbols:position(pos)
end
crystalSymbols:register()

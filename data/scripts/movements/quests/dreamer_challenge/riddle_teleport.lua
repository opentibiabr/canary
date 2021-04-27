local function shuffleTable(t)
	local newTable = {}
	for i = 1, #t do
		randomId = math.random(1, #t)
		newTable[#newTable + 1] = t[randomId]
		table.remove(t, randomId)
	end
	return newTable
end

local arenaPosition = Position(32818, 32334, 9)

local function doResetPillows()
	local storePillows = {}
	for i = 0, 3 do
		local pillowId = 1686 + i
		for i = 1, 9 do
			storePillows[#storePillows + 1] = pillowId
		end
	end

	storePillows = shuffleTable(storePillows)
	for aX = arenaPosition.x, arenaPosition.x + 5 do
		for aY = arenaPosition.y, arenaPosition.y + 5 do
			local pillow = math.random(#storePillows)
			Tile(aX, aY, 9):getThing(1):transform(storePillows[pillow])
			table.remove(storePillows, pillow)
		end
	end
	return true
end

local function checkPillows(posX, posY, item)
	for px = posX, posX + 2 do
		for py = posY, posY + 2 do
			if Tile(px, py, 9):getThing(1).itemid ~= item then
				return false
			end
		end
	end
	return true
end

local riddleTeleport = MoveEvent()

function riddleTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if checkPillows(arenaPosition.x, arenaPosition.y, 1686)
	and checkPillows(arenaPosition.x + 3, arenaPosition.y, 1688)
	and checkPillows(arenaPosition.x, arenaPosition.y + 3, 1687)
	and checkPillows(arenaPosition.x + 3, arenaPosition.y + 3, 1689) then
		player:teleportTo(Position(32766, 32275, 14))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		doResetPillows()
	else
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

riddleTeleport:type("stepin")
riddleTeleport:uid(50147)
riddleTeleport:register()

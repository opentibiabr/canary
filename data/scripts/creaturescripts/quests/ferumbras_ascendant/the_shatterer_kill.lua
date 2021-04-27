local function revertTeleport(position, itemId, transformId, destination)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
		item:setDestination(destination)
	end
end

local chains = {
	West = {
		[1] = {itemid = 23656, position = Position(33401, 32419, 14)},
		[2] = {itemid = 23655, position = Position(33402, 32419, 14)},
		[3] = {itemid = 23655, position = Position(33403, 32419, 14)},
		[4] = {itemid = 23657, position = Position(33404, 32419, 14)},
		[5] = {itemid = 23656, position = Position(33405, 32419, 14)},
		[6] = {itemid = 23657, position = Position(33406, 32419, 14)},
		[7] = {itemid = 1495, position = Position(33403, 32418, 14)},
		[8] = {itemid = 1495, position = Position(33404, 32418, 14)}
	},
	North = {
		[1] = {itemid = 23659, position = Position(33407, 32414, 14)},
		[2] = {itemid = 23658, position = Position(33407, 32415, 14)},
		[3] = {itemid = 23660, position = Position(33407, 32416, 14)},
		[4] = {itemid = 23659, position = Position(33407, 32417, 14)},
		[5] = {itemid = 23660, position = Position(33407, 32418, 14)},
		[6] = {itemid = 1495, position = Position(33406, 32415, 14)},
		[7] = {itemid = 1495, position = Position(33406, 32416, 14)}
	},
	East = {
		[1] = {itemid = 23656, position = Position(33408, 32419, 14)},
		[2] = {itemid = 23657, position = Position(33409, 32419, 14)},
		[3] = {itemid = 23656, position = Position(33410, 32419, 14)},
		[4] = {itemid = 23655, position = Position(33411, 32419, 14)},
		[5] = {itemid = 23657, position = Position(33412, 32419, 14)},
		[6] = {itemid = 1495, position = Position(33408, 32418, 14)},
		[7] = {itemid = 1495, position = Position(33409, 32418, 14)}
	},
	South = {
		[1] = {itemid = 23659, position = Position(33407, 32420, 14)},
		[2] = {itemid = 23660, position = Position(33407, 32421, 14)},
		[3] = {itemid = 23659, position = Position(33407, 32422, 14)},
		[4] = {itemid = 23658, position = Position(33407, 32423, 14)},
		[5] = {itemid = 23660, position = Position(33407, 32424, 14)},
		[6] = {itemid = 1495, position = Position(33406, 32420, 14)},
		[7] = {itemid = 1495, position = Position(33406, 32421, 14)}
	}
}
local levers = {
	[1] = {position = Position(33385, 32410, 14)},
	[2] = {position = Position(33403, 32391, 14)},
	[3] = {position = Position(33430, 32418, 14)},
	[4] = {position = Position(33410, 32441, 14)}
}
local function revert()
	for i = 1, #chains.West do
		local chainWest = chains.West[i]
		Game.createItem(chainWest.itemid, 1, chainWest.position)
	end
	for a = 1, #chains.North do
		local chainNorth = chains.North[a]
		Game.createItem(chainNorth.itemid, 1, chainNorth.position)
	end
	for k = 1, #chains.East do
		local chainEast = chains.East[k]
		Game.createItem(chainEast.itemid, 1, chainEast.position)
	end
	for b = 1, #chains.South do
		local chainSouth = chains.South[b]
		Game.createItem(chainSouth.itemid, 1, chainSouth.position)
	end
	for c = 1, #levers do
		local lever = levers[c]
		local leverT = Tile(lever.position):getItemById(9826)
		if leverT then
			leverT:transform(9825)
		end
	end
end

local theShattererKill = CreatureEvent("TheShattererKill")
function theShattererKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getMaster() or targetMonster:getName():lower() ~= 'the shatterer' then
		return true
	end
	for pid, _ in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(pid)
		if attackerPlayer then
			if targetMonster:getName():lower() == 'the shatterer' then
				attackerPlayer:setStorageValue(Storage.FerumbrasAscension.TheShatterer, 1)
			end
		end
	end
	local teleport = Tile(Position(33393, 32438, 14)):getItemById(1387)
	if not teleport then return true end
	local oldPos = teleport:getDestination()
	local teleportPos = Position(33393, 32438, 14)
	local newPos = Position(33436, 32443, 15)
	if teleport then
		teleport:transform(25417)
		targetMonster:getPosition():sendMagicEffect(CONST_ME_THUNDER)
		teleport:setDestination(newPos)
		addEvent(revertTeleport, 2 * 60 * 1000, teleportPos, 25417, 1387, oldPos)
		revert()
	end
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererLever, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.TheShattererTimer, 0)
	return true
end

theShattererKill:register()

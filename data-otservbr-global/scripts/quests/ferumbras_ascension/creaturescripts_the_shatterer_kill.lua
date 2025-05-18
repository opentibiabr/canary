local function revertTeleport(position, itemId, transformId, destination)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
		item:setDestination(destination)
	end
end

local chains = {
	West = {
		[1] = { itemid = 21285, position = Position(33401, 32419, 14) },
		[2] = { itemid = 21284, position = Position(33402, 32419, 14) },
		[3] = { itemid = 21284, position = Position(33403, 32419, 14) },
		[4] = { itemid = 21286, position = Position(33404, 32419, 14) },
		[5] = { itemid = 21285, position = Position(33405, 32419, 14) },
		[6] = { itemid = 21286, position = Position(33406, 32419, 14) },
		[7] = { itemid = 2126, position = Position(33403, 32418, 14) },
		[8] = { itemid = 2126, position = Position(33404, 32418, 14) },
	},
	North = {
		[1] = { itemid = 21288, position = Position(33407, 32414, 14) },
		[2] = { itemid = 21287, position = Position(33407, 32415, 14) },
		[3] = { itemid = 21289, position = Position(33407, 32416, 14) },
		[4] = { itemid = 21288, position = Position(33407, 32417, 14) },
		[5] = { itemid = 21289, position = Position(33407, 32418, 14) },
		[6] = { itemid = 2126, position = Position(33406, 32415, 14) },
		[7] = { itemid = 2126, position = Position(33406, 32416, 14) },
	},
	East = {
		[1] = { itemid = 21285, position = Position(33408, 32419, 14) },
		[2] = { itemid = 21286, position = Position(33409, 32419, 14) },
		[3] = { itemid = 21285, position = Position(33410, 32419, 14) },
		[4] = { itemid = 21284, position = Position(33411, 32419, 14) },
		[5] = { itemid = 21286, position = Position(33412, 32419, 14) },
		[6] = { itemid = 2126, position = Position(33408, 32418, 14) },
		[7] = { itemid = 2126, position = Position(33409, 32418, 14) },
	},
	South = {
		[1] = { itemid = 21288, position = Position(33407, 32420, 14) },
		[2] = { itemid = 21289, position = Position(33407, 32421, 14) },
		[3] = { itemid = 21288, position = Position(33407, 32422, 14) },
		[4] = { itemid = 21287, position = Position(33407, 32423, 14) },
		[5] = { itemid = 21289, position = Position(33407, 32424, 14) },
		[6] = { itemid = 2126, position = Position(33406, 32420, 14) },
		[7] = { itemid = 2126, position = Position(33406, 32421, 14) },
	},
}

local levers = {
	[1] = { position = Position(33385, 32410, 14) },
	[2] = { position = Position(33403, 32391, 14) },
	[3] = { position = Position(33430, 32418, 14) },
	[4] = { position = Position(33410, 32441, 14) },
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
		local leverT = Tile(lever.position):getItemById(8912)
		if leverT then
			leverT:transform(8911)
		end
	end
end

local teleportPos = Position(33393, 32438, 14)
local newPos = Position(33436, 32443, 15)

local theShattererKill = CreatureEvent("TheShattererDeath")
function theShattererKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShatterer, 1)
	end)

	local teleport = Tile(Position(33393, 32438, 14)):getItemById(1949)
	if not teleport then
		return true
	end
	local oldPos = teleport:getDestination()
	if teleport then
		teleport:transform(22761)
		creature:getPosition():sendMagicEffect(CONST_ME_THUNDER)
		teleport:setDestination(newPos)
		addEvent(revertTeleport, 2 * 60 * 1000, teleportPos, 22761, 1949, oldPos)
		revert()
	end
	Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererLever, 0)
	Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.TheShattererTimer, 0)
	return true
end

theShattererKill:register()

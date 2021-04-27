local config = {
	exitPosition = Position(33265, 31838, 10),
	area = {
		from = Position(33238, 31806, 12),
		to = Position(33297, 31865, 12)
	},
	positions = {
		Position(33272, 31840, 12),
		Position(33263, 31840, 12),
		Position(33263, 31831, 12),
		Position(33272, 31831, 12)
	},
	leverPositions = {
		Position(33273, 31831, 12),
		Position(33273, 31840, 12),
		Position(33262, 31840, 12),
		Position(33262, 31831, 12)
	},
	walls = {
		{from = Position(33275, 31834, 12), to = Position(33275, 31838, 12), wallId = 5072, soundPosition = Position(33275, 31836, 12)},
		{from = Position(33266, 31843, 12), to = Position(33270, 31843, 12), wallId = 5071, soundPosition = Position(33268, 31843, 12)},
		{from = Position(33260, 31834, 12), to = Position(33260, 31838, 12), wallId = 5072, soundPosition = Position(33260, 31836, 12)},
		{from = Position(33266, 31828, 12), to = Position(33270, 31828, 12), wallId = 5071, soundPosition = Position(33268, 31828, 12)}
	},
	roomArea = {
		from = Position(33261, 31829, 12),
		to = Position(33274, 31842, 12)
	},
	machineStorages = {GlobalStorage.ElementalSphere.Machine1, GlobalStorage.ElementalSphere.Machine2, GlobalStorage.ElementalSphere.Machine3, GlobalStorage.ElementalSphere.Machine4},
	centerPosition = Position(33267, 31836, 12),
	effectPositions = {
		Position(33261, 31829, 12), Position(33262, 31830, 12), Position(33263, 31831, 12),
		Position(33264, 31832, 12), Position(33265, 31833, 12), Position(33266, 31834, 12),
		Position(33267, 31835, 12), Position(33268, 31836, 12), Position(33269, 31837, 12),
		Position(33270, 31838, 12), Position(33271, 31839, 12), Position(33272, 31840, 12),
		Position(33273, 31841, 12), Position(33274, 31842, 12), Position(33274, 31829, 12),
		Position(33273, 31830, 12), Position(33272, 31831, 12), Position(33271, 31832, 12),
		Position(33270, 31833, 12), Position(33269, 31834, 12), Position(33268, 31835, 12),
		Position(33267, 31836, 12), Position(33266, 31837, 12), Position(33265, 31838, 12),
		Position(33264, 31839, 12), Position(33263, 31840, 12), Position(33262, 31841, 12),
		Position(33261, 31842, 12)
	}
}


local function resetRoom(players)
	for i = 1, #players do
		local player = Player(players[i])
		if player and isInRange(player:getPosition(), config.area.from, config.area.to) then
			player:teleportTo(config.exitPosition)
			config.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	for i = 1, #config.walls do
		local wall = config.walls[i]
		for x = wall.from.x, wall.to.x do
			for y = wall.from.y, wall.to.y do
				local wallItem = Tile(Position(x, y, wall.from.z)):getItemById(wall.wallId)
				if wallItem then
					wallItem:remove()
				end
			end
		end
	end

	local creature = Creature('lord of the elements')
	if creature then
		creature:remove()
	end

	for i = 1, #config.leverPositions do
		local leverItem = Tile(config.leverPositions[i]):getItemById(1946)
		if leverItem then
			leverItem:transform(1945)
		end
	end

	Game.setStorageValue(GlobalStorage.ElementalSphere.BossRoom, -1)
	for i = 1, #config.machineStorages do
		Game.setStorageValue(config.machineStorages[i], -1)
	end
	return true
end

local function warnPlayers(players)
	local player
	for i = 1, #players do
		player = Player(players[i])
		if player and isInRange(player:getPosition(), config.roomArea.from, config.roomArea.to) then
			break
		end
		player = nil
	end

	if not player then
		return
	end

	player:say('You have 5 minutes from now on until you get teleported out.', TALKTYPE_MONSTER_YELL, false, 0, Position(33266, 31835, 13))
end

local function areMachinesCharged()
	for i = 1, #config.machineStorages do
		if Game.getStorageValue(config.machineStorages[i]) <= 0 then
			return false
		end
	end
	return true
end

local elementalSpheresLordLever = Action()
function elementalSpheresLordLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return true
	end

	for i = 1, #config.machineStorages do
		Game.setStorageValue(config.machineStorages[i], 1)
	end

	if not areMachinesCharged() then
		return false
	end

	local index = table.find(config.positions, player:getPosition())
	if not index then
		return false
	end

	item:transform(1946)
	local leverCount = 0
	for i = 1, #config.leverPositions do
		if Tile(config.leverPositions[i]):getItemById(1946) then
			leverCount = leverCount + 1
		end
	end

	local walls = config.walls[index]
	for x = walls.from.x, walls.to.x do
		for y = walls.from.y, walls.to.y do
			Game.createItem(walls.wallId, 1, Position(x, y, walls.from.z))
		end
	end
	player:say('ZOOOOOOOOM', TALKTYPE_MONSTER_SAY, false, 0, walls.soundPosition)

	if leverCount ~= #config.leverPositions then
		return true
	end

	local players = {}
	for i = 1, #config.positions do
		local creature = Tile(config.positions[i]):getTopCreature()
		if creature then
			players[#players + 1] = creature.uid
		end
	end

	Game.setStorageValue(GlobalStorage.ElementalSphere.BossRoom, 1)
	Game.createMonster('Lord of the Elements', config.centerPosition)
	player:say('You have 10 minutes from now on until you get teleported out.', TALKTYPE_MONSTER_YELL, false, 0, config.centerPosition)
	addEvent(warnPlayers, 5 * 60 * 1000, players)
	addEvent(resetRoom, 10 * 60 * 1000, players)

	for i = 1, #config.effectPositions do
		config.effectPositions[i]:sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

elementalSpheresLordLever:uid(1011, 1012, 1013, 1014)
elementalSpheresLordLever:register()
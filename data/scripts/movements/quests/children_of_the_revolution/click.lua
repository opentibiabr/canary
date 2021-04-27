local config = {
	positions = {
		({x = 33258, y = 31080, z = 8}),
		({x = 33266, y = 31084, z = 8}),
		({x = 33259, y = 31089, z = 8}),
		({x = 33263, y = 31093, z = 8})
	},
	stairPosition = Position(33265, 31116, 8),
	areaCenter = Position(33268, 31119, 7),
	zalamonPosition = Position(33353, 31410, 8),

	summonArea = {
		from = Position(33252, 31105, 7),
		to = Position(33288, 31134, 7)
	},
	waves = {
		{monster = 'eternal guardian', size = 20},
		{monster = 'eternal guardian', size = 20},
		{monster = 'eternal guardian', size = 20},
		{monster = 'lizard chosen', size = 20}
	}
}

function doClearMissionArea()
	Game.setStorageValue(Storage.ChildrenoftheRevolution.Mission05, -1)

	local spectators, spectator = Game.getSpectators(config.areaCenter, false, true, 26, 26, 20, 20)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(config.zalamonPosition)
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			if spectator:getStorageValue(Storage.ChildrenoftheRevolution.Questline) == 19 then
				spectator:setStorageValue(Storage.ChildrenoftheRevolution.Questline, 20)
			end
		else
			spectator:remove()
		end
	end
	return true
end

local function removeStairs()
	local stair = Tile(config.stairPosition):getItemById(3687)
	if stair then
		stair:transform(3653)
	end
end

local function summonWave(i)
	local wave = config.waves[i]
	local summonPosition
	for i = 1, wave.size do
		summonPosition = Position(math.random(config.summonArea.from.x,
		config.summonArea.to.x), math.random(config.summonArea.from.y, config.summonArea.to.y), 7)
		Game.createMonster(wave.monster, summonPosition)
		summonPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
end

local click = MoveEvent()

function click.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.ChildrenoftheRevolution.Questline) ~= 19
	or Game.getStorageValue(Storage.ChildrenoftheRevolution.Mission05) == 1 then
		return true
	end

	local players = {}
	for i = 1, #config.positions do
		local creature = Tile(Position(config.positions[i])):getTopCreature()
		if creature and creature:isPlayer() then
			players[#players + 1] = creature
		end
	end

	if #players ~= #config.positions then
		return true
	end

	for i = 1, #players do
		players[i]:say('A clicking sound tatters the silence.', TALKTYPE_MONSTER_SAY)
	end

	local stair = Tile(config.stairPosition):getItemById(3653)
	if stair then
		stair:transform(3687)
	end
	Game.setStorageValue(Storage.ChildrenoftheRevolution.Mission05, 1)

	for wave = 1, #config.waves do
		addEvent(summonWave, wave * 30 * 1000, wave)
	end
	addEvent(removeStairs, 30 * 1000)
	addEvent(doClearMissionArea, 5 * 30 * 1000)
	return true
end

click:type("stepin")
click:aid(8014)
click:register()

local function startWaves()
	Game.setStorageValue(GlobalStorage.HeroRathleton.DeepRunning, 1)
	if Game.getStorageValue(GlobalStorage.HeroRathleton.TentacleWave) < 9 then
		for i = 1, 7 do
			Game.createMonster("glooth anemone", Position(math.random(33736, 33746),
			math.random(31948, 31957), 14), true, true)
		end
	elseif Game.getStorageValue(GlobalStorage.HeroRathleton.TentacleWave) == 9 then
		for i = 1, 4 do
			Game.createMonster("tentacle of the deep terror", Position(math.random(33736, 33746),
			math.random(31948, 31957), 14), true, true)
		end
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.TentacleWave,
	Game.getStorageValue(GlobalStorage.HeroRathleton.TentacleWave) + 1)
	if Game.getStorageValue(GlobalStorage.HeroRathleton.TentacleWave) > 9 then
		return true
	end
	addEvent(startWaves, 40 * 1000)
end

local function clearArea()
	local spectators = Game.getSpectators(Position(33740, 31953, 14), false, false, 13, 13, 13, 13)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(33724, 31953, 14))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say("Time out!", TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.DeepRunning, 0)
end

local deepTerror = MoveEvent()

function deepTerror.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorage.HeroRathleton.DeepRunning) == 1 then
		player:say("Has someone fighting against Deep Terror. \nTry again later.", TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33724, 31951, 14))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.FirstMachines) < 8 then
		player:say("No energy enough to use this teleport!", TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33724, 31951, 14))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.FirstMachines) == 8 then
		if Game.getStorageValue(GlobalStorage.HeroRathleton.DeepRunning) < 1 then
			addEvent(Game.setStorageValue, 3 * 60 * 1000, GlobalStorage.HeroRathleton.DeepRunning, 1)
			addEvent(startWaves, 3 * 60 * 1000)
			addEvent(Game.setStorageValue, 3 * 60 * 1000, GlobalStorage.HeroRathleton.TentacleWave, 0)
			addEvent(clearArea, 20 * 60 * 1000)
		end
		player:teleportTo(Position(33738, 31953, 14))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

deepTerror:type("stepin")
deepTerror:aid(24862)
deepTerror:register()

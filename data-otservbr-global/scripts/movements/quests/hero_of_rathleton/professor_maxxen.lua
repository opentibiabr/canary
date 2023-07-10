local function startWaves()
	local position = math.random(33704, 33718), math.random(32040, 32053), 15
	Game.setStorageValue(GlobalStorage.HeroRathleton.MaxxenRunning, 1)
	if Game.getStorageValue(GlobalStorage.HeroRathleton.GloothWave) < 8 then
		for i = 1, 4 do
			local chance = math.random(2)
			if chance == 1 then
				Game.createMonster("glooth masher", Position(position), true, true)
			else
				Game.createMonster("glooth golem", Position(position), true, true)
			end
		end
	elseif Game.getStorageValue(GlobalStorage.HeroRathleton.GloothWave) == 8 then
		for i = 1, 4 do
			local chance = math.random(3)
			if chance == 1 then
				Game.createMonster("glooth trasher", Position(position), true, true)
			elseif chance == 2 then
				Game.createMonster("glooth slasher", Position(position), true, true)
			else
				Game.createMonster("glooth golem", Position(position), true, true)
			end
		end
		Game.createMonster("professor maxxen", Position(33711, 32046, 15), true, true)
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.GloothWave,
		Game.getStorageValue(GlobalStorage.HeroRathleton.GloothWave) + 1)
	if Game.getStorageValue(GlobalStorage.HeroRathleton.GloothWave) > 8 then
		return true
	end
	addEvent(startWaves, 40 * 1000)
end

local function clearArea()
	local spectators = Game.getSpectators(Position(33711, 32046, 15), false, false, 13, 13, 13, 13)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(33661, 32058, 15))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say("Time out!", TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.MaxxenRunning, 0)
end

local professorMaxxen = MoveEvent()

function professorMaxxen.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(GlobalStorage.HeroRathleton.AccessTeleport3) < 1 then
		player:teleportTo(Position(33661, 32058, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You haven't permission to use this teleport.", TALKTYPE_MONSTER_SAY, false, nil, position)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.MaxxenRunning) == 1 then
		player:say("Has someone fighting against Professor Maxxen.\nTry again later.",
			TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33661, 32058, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.ThirdMachines) < 8 then
		player:say("No energy enough to use this teleport!", TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33661, 32058, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.ThirdMachines) == 8 then
		if Game.getStorageValue(GlobalStorage.HeroRathleton.MaxxenRunning) < 1 then
			addEvent(Game.setStorageValue, 3 * 60 * 1000, GlobalStorage.HeroRathleton.MaxxenRunning, 1)
			addEvent(startWaves, 3 * 60 * 1000)
			addEvent(Game.setStorageValue, 3 * 60 * 1000, GlobalStorage.HeroRathleton.GloothWave, 0)
			addEvent(clearArea, 20 * 60 * 1000)
		end
		player:teleportTo(Position(33711, 32052, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

professorMaxxen:type("stepin")
professorMaxxen:aid(24868)
professorMaxxen:register()

local function startWaves()
	Game.setStorageValue(GlobalStorage.HeroRathleton.HorrorRunning, 1)
	if Game.getStorageValue(GlobalStorage.HeroRathleton.DevourerWave) < 9 then
		for i = 1, 6 do
			Game.createMonster("rot elemental", Position(math.random(33548, 33562), math.random(31949, 31962), 15), true, true)
			Game.createMonster("devourer", Position(math.random(33548, 33562), math.random(31949, 31962), 15), true, true)
		end
	elseif Game.getStorageValue(GlobalStorage.HeroRathleton.DevourerWave) == 9 then
		Game.createMonster("feeble glooth horror", Position(33555, 31956, 15), true, true)
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.DevourerWave,
	Game.getStorageValue(GlobalStorage.HeroRathleton.DevourerWave) + 1)
	if Game.getStorageValue(GlobalStorage.HeroRathleton.DevourerWave) > 9 then
		return true
	end
	addEvent(startWaves, 40 * 1000)
end

local function clearArea()
	local spectators = Game.getSpectators(Position(33555, 31956, 15), false, false, 13, 13, 13, 13)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(Position(33573, 31949, 15))
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spectator:say("Time out!", TALKTYPE_MONSTER_SAY)
		elseif spectator:isMonster() then
			spectator:remove()
		end
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.HorrorRunning, 0)
end

local gloothHorror = MoveEvent()

function gloothHorror.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(GlobalStorage.HeroRathleton.AccessTeleport1) < 1 then
		player:teleportTo(Position(33571, 31947, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You haven't permission to use this teleport.", TALKTYPE_MONSTER_SAY, false, nil, position)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.HorrorRunning) == 1 then
		player:say("Has someone fighting against Glooth Horror. \nTry again later.",
		TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33571, 31947, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.SecondMachines) < 8 then
		player:say("No energy enough to use this teleport!", TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33571, 31947, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.SecondMachines) == 8 then
		if Game.getStorageValue(GlobalStorage.HeroRathleton.HorrorRunning) < 1 then
			addEvent(Game.setStorageValue, 3 * 60 * 1000, GlobalStorage.HeroRathleton.HorrorRunning, 1)
			addEvent(startWaves, 3 * 60 * 1000)
			addEvent(Game.setStorageValue, 3 * 60 * 1000, GlobalStorage.HeroRathleton.DevourerWave, 0)
			addEvent(clearArea, 20 * 60 * 1000)
		end
		player:teleportTo(Position(33561, 31954, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

gloothHorror:type("stepin")
gloothHorror:aid(24864)
gloothHorror:register()

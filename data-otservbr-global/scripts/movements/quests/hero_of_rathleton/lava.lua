local changes = {
	[1] = {centerPos = Position(33552, 32049, 15), nextPos = Position(33552, 32082, 15)},
	[2] = {centerPos = Position(33552, 32082, 15), nextPos = Position(33552, 32115, 15)},
	[3] = {centerPos = Position(33552, 32115, 15), nextPos = Position(33552, 32148, 15)},
	[4] = {centerPos = Position(33552, 32148, 15), nextPos = Position(33584, 32148, 15)},
	[5] = {centerPos = Position(33584, 32148, 15), nextPos = Position(33616, 32148, 15)},
	[6] = {centerPos = Position(33616, 32148, 15), nextPos = Position(33648, 32148, 15)},
	[7] = {centerPos = Position(33648, 32148, 15), nextPos = Position(33611, 32055, 15)}
}

local function checkCounter()
	local storage = Game.getStorageValue(GlobalStorage.HeroRathleton.LavaChange)
	if storage == 7 then
		local spectators = Game.getSpectators(changes[storage].centerPos, false, false, 13, 13, 13, 13)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isPlayer() then
				spectator:teleportTo(Position(33611, 32055, 15))
				spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				spectator:addAchievement("Go with da Lava Flow")
			elseif spectator:isMonster() then
				spectator:remove()
			end
		end
		Game.setStorageValue(GlobalStorage.HeroRathleton.LavaChange, 0)
		Game.setStorageValue(GlobalStorage.HeroRathleton.LavaRunning, 0)
		stopEvent(checkCounter)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.LavaCounter) < 5 then
		local spectators = Game.getSpectators(changes[storage].centerPos, false, false, 13, 13, 13, 13)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:isPlayer() then
				spectator:teleportTo(Position(33371, 31955, 15))
				spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			elseif spectator:isMonster() then
				spectator:remove()
			end
		end
		Game.setStorageValue(GlobalStorage.HeroRathleton.LavaChange, 0)
		Game.setStorageValue(GlobalStorage.HeroRathleton.LavaRunning, 0)
		stopEvent(checkCounter)
		return true
	end
	local spectators = Game.getSpectators(changes[storage].centerPos, false, false, 13, 13, 13, 13)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(changes[storage].nextPos)
		end
	end
	if storage < 7 then
		for p = 1, 5 do
			addEvent(Game.createMonster, 15 * 1000, "raging fire", changes[storage].nextPos, true, true)
		end
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.LavaChange,
	Game.getStorageValue(GlobalStorage.HeroRathleton.LavaChange) + 1)
	Game.setStorageValue(GlobalStorage.HeroRathleton.LavaCounter, 0)
	return true
end

local lava = MoveEvent()

function lava.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(GlobalStorage.HeroRathleton.AccessTeleport2) < 1 then
		player:teleportTo(Position(33371, 31955, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You haven't permission to use this teleport.", TALKTYPE_MONSTER_SAY, false, nil, position)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.LavaRunning) == 1 then
		player:say("Has someone trying active the machine. Try again later.", TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33371, 31955, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.FourthMachines) < 7 then
		player:say("No energy enough to use this teleport!", TALKTYPE_MONSTER_SAY, false, nil, position)
		player:teleportTo(Position(33371, 31955, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if Game.getStorageValue(GlobalStorage.HeroRathleton.FourthMachines) == 7 then
		if Game.getStorageValue(GlobalStorage.HeroRathleton.LavaRunning) < 1 then
			addEvent(Game.setStorageValue, 1 * 30 * 1000, GlobalStorage.HeroRathleton.LavaRunning, 1)
			for i = 1, 5 do
				addEvent(Game.createMonster, 1 * 30 * 1000, "raging fire", Position(33552, 32049, 15), true, true)
			end
			for a = 1, 7 do
				addEvent(checkCounter, a * 60 * 1000)
			end
		end
		Game.setStorageValue(GlobalStorage.HeroRathleton.LavaChange, 1)
		player:teleportTo(Position(33552, 32049, 15))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

lava:type("stepin")
lava:aid(24866)
lava:register()

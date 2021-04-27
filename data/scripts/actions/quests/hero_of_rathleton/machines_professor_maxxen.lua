local function revertMachine(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.ThirdMachines, Game.getStorageValue(GlobalStorage.HeroRathleton.ThirdMachines) - 1)
end

local heroRathletonProfessor = Action()
function heroRathletonProfessor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 24112 then
		return false
	end

	if Game.getStorageValue(GlobalStorage.HeroRathleton.MaxxenRunning) >= 1 then
		player:say('Impossible to turn on this machine for now!', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
		return true
	end

	if Game.getStorageValue(GlobalStorage.HeroRathleton.ThirdMachines) == 7 then
		player:say('All machines are working, now is possible to use the teleport at east.', TALKTYPE_MONSTER_SAY)
	end

	item:transform(24113)
	addEvent(revertMachine, 10 * 60 * 1000, toPosition, 24113, 24112)
	Game.setStorageValue(GlobalStorage.HeroRathleton.ThirdMachines, Game.getStorageValue(GlobalStorage.HeroRathleton.ThirdMachines) + 1)
	player:say('~Zzzz~\n The machine is working!', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
	return true
end

heroRathletonProfessor:aid(9299)
heroRathletonProfessor:register()
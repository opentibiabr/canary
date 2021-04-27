local function revertMachine(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
	Game.setStorageValue(GlobalStorage.HeroRathleton.FourthMachines, Game.getStorageValue(GlobalStorage.HeroRathleton.FourthMachines) - 1)
end

local heroRathletonLava = Action()
function heroRathletonLava.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 24112 then
		return false
	end

	if Game.getStorageValue(GlobalStorage.HeroRathleton.LavaRunning) >= 1 then
		player:say('Impossible to turn on this machine for now!', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
		return true
	end

	if Game.getStorageValue(GlobalStorage.HeroRathleton.FourthMachines) == 7 then
		player:say('All machines are working, now is possible to use the teleport at west.', TALKTYPE_MONSTER_SAY)
	end

	item:transform(24113)
	addEvent(revertMachine, 10 * 60 * 1000, toPosition, 24113, 24112)
	Game.setStorageValue(GlobalStorage.HeroRathleton.FourthMachines, Game.getStorageValue(GlobalStorage.HeroRathleton.FourthMachines) + 1)
	player:say('~Zzzz~\n The machine is working!', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
	return true
end

heroRathletonLava:aid(24865)
heroRathletonLava:register()
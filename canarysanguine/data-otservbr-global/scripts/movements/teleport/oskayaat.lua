SimpleTeleport(Position(33028, 32953, 8), Position(33042, 32950, 9))
SimpleTeleport(Position(33043, 32950, 9), Position(33028, 32952, 8))

local wallTeleport = Action()
function wallTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition().y < 32915 then
		player:teleportTo(Position(33038, 32916, 9))
	else
		player:teleportTo(Position(33038, 32914, 9))
	end
	return true
end

wallTeleport:position(Position(33038, 32915, 9))
wallTeleport:register()

local boatExit = Action()
function boatExit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:teleportTo(Position(33176, 32882, 7))
	return true
end

boatExit:position(Position(33069, 32915, 7))
boatExit:register()

local boatEntry = Action()
function boatEntry.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:teleportTo(Position(33069, 32916, 7))
	return true
end

boatEntry:position(Position(33176, 32883, 7))
boatEntry:register()

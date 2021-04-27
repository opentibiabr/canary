local elementalSpheresMachine2 = Action()
function elementalSpheresMachine2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInRange(toPosition, Position(33238, 31806, 12), Position(33297, 31865, 12)) then
		return false
	end

	if isInArray({7913, 7914}, item.itemid) then
		toPosition.y = toPosition.y + (item.itemid == 7913 and 1 or -1)
		local machineItem = Tile(toPosition):getItemById(item.itemid == 7913 and 7914 or 7913)
		if machineItem then
			machineItem:transform(machineItem.itemid + 4)
		end
		item:transform(item.itemid + 4)
		player:say('ON', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	else
		toPosition.y = toPosition.y + (item.itemid == 7917 and 1 or -1)
		local machineItem = Tile(toPosition):getItemById(item.itemid == 7917 and 7918 or 7917)
		if machineItem then
			machineItem:transform(machineItem.itemid - 4)
		end
		item:transform(item.itemid - 4)
		player:say('OFF', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	end
	return true
end

elementalSpheresMachine2:id(7913,7914,7917,7918)
elementalSpheresMachine2:register()
local elementalSpheresMachine2 = Action()
function elementalSpheresMachine2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInRange(toPosition, Position(33238, 31806, 12), Position(33297, 31865, 12)) then
		return false
	end

	if isInArray({844, 845}, item.itemid) then
		toPosition.y = toPosition.y + (item.itemid == 844 and 1 or -1)
		local machineItem = Tile(toPosition):getItemById(item.itemid == 844 and 845 or 844)
		if machineItem then
			machineItem:transform(machineItem.itemid + 4)
		end
		item:transform(item.itemid + 4)
		player:say('ON', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	else
		toPosition.y = toPosition.y + (item.itemid == 848 and 1 or -1)
		local machineItem = Tile(toPosition):getItemById(item.itemid == 848 and 845 or 849)
		if machineItem then
			machineItem:transform(machineItem.itemid - 4)
		end
		item:transform(item.itemid - 4)
		player:say('OFF', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	end
	return true
end

elementalSpheresMachine2:id(844, 845, 848, 849)
elementalSpheresMachine2:register()
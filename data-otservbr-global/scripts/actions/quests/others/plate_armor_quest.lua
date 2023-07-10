local othersPlateArmor = Action()
function othersPlateArmor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GhostShipQuest) == 1 then
		return false
	end

	player:setStorageValue(Storage.GhostShipQuest, 1)
	player:addItem(3357, 1)
	return true
end

othersPlateArmor:aid(5556)
othersPlateArmor:register()
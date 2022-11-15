local ferumbrasAscendantHabitatLever = Action()
function ferumbrasAscendantHabitatLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FerumbrasAscension.HabitatsAccess) >= 1 then
		return false
	end

	if item.itemid == 9125 then
			player:setStorageValue(Storage.FerumbrasAscension.HabitatsAccess, 1)
		item:transform(9126)
	elseif item.itemid == 9126 then
		item:transform(9125)
	end
	return true
end

ferumbrasAscendantHabitatLever:aid(34324)
ferumbrasAscendantHabitatLever:register()
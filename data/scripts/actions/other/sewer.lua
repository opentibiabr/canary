local sewer = Action()

function sewer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains(435, item.itemid) then
		fromPosition.z = fromPosition.z + 1
	end
	player:teleportTo(fromPosition, false)
	return true
end

sewer:id(435)
sewer:register()

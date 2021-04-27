local teleportDrawWell = Action()

function teleportDrawWell.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getActionId() ~= 1000 then
		return false
	end

	fromPosition.z = fromPosition.z + 1
	player:teleportTo(fromPosition)
	return true
end

teleportDrawWell:id(1369)
teleportDrawWell:register()

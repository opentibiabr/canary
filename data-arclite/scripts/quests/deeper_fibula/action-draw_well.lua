local drawWell = Action()

function drawWell.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:teleportTo({x = 32172, y = 32439, z = 8})
	return true
end

drawWell:aid(15005)
drawWell:register()

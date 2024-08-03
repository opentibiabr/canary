local downFloor = Action()

function downFloor.onUse(player, item, fromPosition, itemEx, toPosition)
	fromPosition.x = fromPosition.x + 1
	fromPosition.z = fromPosition.z + 1
	player:teleportTo(fromPosition, false)
	return true
end

downFloor:aid(102)
downFloor:register()

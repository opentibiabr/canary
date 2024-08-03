local teleportWest = Action()

function teleportWest.onUse(cid, item, fromPosition, itemEx, toPosition)
	fromPosition.z = fromPosition.z - 1
	doTeleportThing(cid, fromPosition, false)
	return true
end

teleportWest:id(20573)
teleportWest:register()

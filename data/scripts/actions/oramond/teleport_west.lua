local teleportWest = Action()

function teleportWest.onUse(cid, item, fromPosition, itemEx, toPosition)
	fromPosition.z = fromPosition.z - 1
	doTeleportThing(cid, fromPosition, FALSE)
	return TRUE
end

teleportWest:id(22944)
teleportWest:register()

local teleportNorth = Action()

function teleportNorth.onUse(cid, item, fromPosition, itemEx, toPosition)
	fromPosition.z = fromPosition.z - 1
	doTeleportThing(cid, fromPosition, FALSE)
	return TRUE
end

teleportNorth:id(22949)
teleportNorth:register()

local upFloorIds = {23668}

local sewerGrateTeleport = Action()

function sewerGrateTeleport.onUse(cid, item, fromPosition, itemEx, toPosition)
	if isInArray(upFloorIds, item.itemid) == TRUE then
		fromPosition.x = fromPosition.x + 1
		fromPosition.z = fromPosition.z - 2
	end
	doTeleportThing(cid, fromPosition, FALSE)
	return TRUE
end

sewerGrateTeleport:id(23668)
sewerGrateTeleport:register()

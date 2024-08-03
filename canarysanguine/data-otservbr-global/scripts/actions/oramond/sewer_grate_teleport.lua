local upFloorIds = { 21297 }

local sewerGrateTeleport = Action()

function sewerGrateTeleport.onUse(cid, item, fromPosition, itemEx, toPosition)
	if table.contains(upFloorIds, item.itemid) then
		fromPosition.x = fromPosition.x + 1
		fromPosition.z = fromPosition.z - 2
	end
	doTeleportThing(cid, fromPosition, false)
	return true
end

sewerGrateTeleport:id(21297)
sewerGrateTeleport:register()

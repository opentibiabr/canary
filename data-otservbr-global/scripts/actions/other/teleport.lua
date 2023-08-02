local ladderTable = Game.getLadderTable()

local upFloorIds = ladderTable

local teleport = Action()

function teleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains(upFloorIds, item.itemid) then
		fromPosition:moveUpstairs()
	else
		fromPosition.z = fromPosition.z + 1
	end
	player:teleportTo(fromPosition, false)
	return true
end

-- Gate
teleport:id(435)
teleport:id(unpack(ladderTable))
teleport:register()

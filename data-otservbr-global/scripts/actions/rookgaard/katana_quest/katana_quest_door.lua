local doorPosition = Position(32177, 32148, 11)
local leverPosition = Position(32182, 32145, 11)

local katanaQuestDoor = Action()

function katanaQuestDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local doorItem = Tile(doorPosition):getItemById(5108)
	if doorItem then
		doorItem:transform(5107)
		doorItem:setAttribute(ITEM_ATTRIBUTE_UNIQUEID, 22006)
	end
	local leverItem = Tile(leverPosition):getItemById(2773)
	if leverItem then
		leverItem:transform(2772)
	end
	return false
end

katanaQuestDoor:uid(22006)
katanaQuestDoor:register()

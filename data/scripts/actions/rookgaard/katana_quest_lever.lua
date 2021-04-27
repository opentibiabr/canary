local doorPosition = Position(32177, 32148, 11)
local relocatePosition = Position(32178, 32148, 11)

local katanaQuestLever = Action()

function katanaQuestLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local doorItem = Tile(doorPosition):getItemById(5108)
		if doorItem then
			doorItem:transform(5109)
			doorItem:setAttribute(ITEM_ATTRIBUTE_UNIQUEID, 1055)
			item:transform(1946)
		end
	else
		local tile = Tile(doorPosition)
		local doorItem = tile:getItemById(5109)
		if doorItem then
			tile:relocateTo(relocatePosition, true)
			doorItem:transform(5108)
			doorItem:setAttribute(ITEM_ATTRIBUTE_UNIQUEID, 1055)
			item:transform(1945)
		end
	end
	return true
end

katanaQuestLever:uid(1054)
katanaQuestLever:register()

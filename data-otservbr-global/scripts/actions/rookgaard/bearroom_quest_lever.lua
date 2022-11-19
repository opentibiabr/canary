local stonePosition = Position(32145, 32101, 11)
local relocatePosition = Position(32145, 32102, 11)

local bearRoomQuestLever = Action()

function bearRoomQuestLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		local stoneItem = Tile(stonePosition):getItemById(1791)
		if stoneItem then
			stoneItem:remove()
			item:transform(2773)
		end
	else
		Tile(stonePosition):relocateTo(relocatePosition)
		Game.createItem(1791, 1, stonePosition)
		item:transform(2772)
	end
	return true
end

bearRoomQuestLever:uid(1056)
bearRoomQuestLever:register()

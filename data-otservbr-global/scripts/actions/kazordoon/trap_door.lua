local exitPosition = Position(32605, 31902, 4)

local trapDoor = Action()

function trapDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local ground = Tile(exitPosition):getGround()
	if ground and isInArray({369, 416}, ground.itemid) then
		ground:transform(ground.itemid == 369 and 416 or 369)

		if ground.itemid == 369 then
			local items = ground:getTile():getItems()
			if items then
				exitPosition.z = exitPosition.z + 1
				for i = 1, #items do
					items[i]:moveTo(exitPosition)
				end
			end
		end
	end

	item:transform(item.itemid == 2772 and 2773 or 2772)
	return true
end

trapDoor:aid(50238)
trapDoor:register()

local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local ferumbrasAscendantGraveFlower = Action()
function ferumbrasAscendantGraveFlower.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(25530)
	player:addItem(2747, 1)
	addEvent(revertItem, 2 * 60 * 1000, toPosition, 25530, 25529)
	return true
end

ferumbrasAscendantGraveFlower:id(25529)
ferumbrasAscendantGraveFlower:register()
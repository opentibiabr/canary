local pitsOfInfernoMazeStone = Action()
function pitsOfInfernoMazeStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2773 then
		return false
	end

	toPosition.x = toPosition.x - 1
	toPosition.y = toPosition.y + 1

	local stone = Tile(toPosition):getItemById(1791)
	if stone then
		stone:remove()
	end

	item:transform(2773)
	return true
end

pitsOfInfernoMazeStone:aid(50160)
pitsOfInfernoMazeStone:register()

local pitsOfInfernoMazeStone = Action()
function pitsOfInfernoMazeStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1946 then
		return false
	end

	toPosition.x = toPosition.x - 1
	toPosition.y = toPosition.y + 1

	local stone = Tile(toPosition):getItemById(1304)
	if stone then
		stone:remove()
	end

	item:transform(1946)
	return true
end

pitsOfInfernoMazeStone:aid(50160)
pitsOfInfernoMazeStone:register()
local pitsOfInfernoTrapLever = Action()
function pitsOfInfernoTrapLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	item:transform(item.itemid == 1945 and 1946 or 1945)

	if item.itemid ~= 1945 then
		return true
	end

	local stoneItem = Tile(Position(32826, 32274, 11)):getItemById(1285)
	if stoneItem then
		stoneItem:remove()
	end
	return true
end

pitsOfInfernoTrapLever:uid(3304)
pitsOfInfernoTrapLever:register()
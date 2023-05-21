local pitsOfInfernoTrapLever = Action()
function pitsOfInfernoTrapLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	item:transform(item.itemid == 2772 and 2773 or 2772)

	if item.itemid ~= 2772 then
		return true
	end

	local stoneItem = Tile(Position(32826, 32274, 11)):getItemById(1772)
	if stoneItem then
		stoneItem:remove()
	end
	return true
end

pitsOfInfernoTrapLever:uid(3304)
pitsOfInfernoTrapLever:register()
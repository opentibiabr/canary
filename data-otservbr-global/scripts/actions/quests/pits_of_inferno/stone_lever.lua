local pitsOfInfernoStoneLever = Action()
function pitsOfInfernoStoneLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2772 then
		local stonePosition = Position(32849, 32282, 10)
		local stoneItem = Tile(stonePosition):getItemById(1791)
		if stoneItem then
			stoneItem:remove()
			stonePosition:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
			item:transform(2773)
		end
	end
	return true
end

pitsOfInfernoStoneLever:uid(3300)
pitsOfInfernoStoneLever:register()
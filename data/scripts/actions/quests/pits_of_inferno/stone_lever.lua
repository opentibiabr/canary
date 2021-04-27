local pitsOfInfernoStoneLever = Action()
function pitsOfInfernoStoneLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local stonePosition = Position(32849, 32282, 10)
		local stoneItem = Tile(stonePosition):getItemById(1304)
		if stoneItem then
			stoneItem:remove()
			stonePosition:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
			item:transform(1946)
		end
	end
	return true
end

pitsOfInfernoStoneLever:uid(3300)
pitsOfInfernoStoneLever:register()
local bathtubDrain = Action()

function bathtubDrain.onUse(player, item, fromPosition, itemEx, toPosition)
	local tile = Tile(fromPosition)
	if tile:getTopCreature() then
		return false
	end

	item:transform(BATHTUB_EMPTY)
end

bathtubDrain:id(BATHTUB_FILLED)
bathtubDrain:register()

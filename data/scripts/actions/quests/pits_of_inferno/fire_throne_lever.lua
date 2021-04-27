local lava = {
	Position(32912, 32209, 15),
	Position(32913, 32209, 15),
	Position(32912, 32210, 15),
	Position(32913, 32210, 15)
}

local pitsOfInfernoFirstThroneLever = Action()
function pitsOfInfernoFirstThroneLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lavaTile
	for i = 1, #lava do
		lavaTile = Tile(lava[i]):getGround()
		if lavaTile and isInArray({407, 598}, lavaTile.itemid) then
			lavaTile:transform(lavaTile.itemid == 598 and 407 or 598)
			lava[i]:sendMagicEffect(CONST_ME_SMOKE)
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

pitsOfInfernoFirstThroneLever:uid(50106)
pitsOfInfernoFirstThroneLever:register()
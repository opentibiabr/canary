local cake = MoveEvent()

function cake.onAddItem(moveitem, tileitem, position)
	-- has to be a candle
	if moveitem.itemid ~= 2918 then
		return true
	end

	moveitem:remove()
	tileitem:transform(6279)
	position:sendMagicEffect(CONST_ME_MAGIC_RED)
	return true
end

cake:type("additem")
cake:id(6278)
cake:register()

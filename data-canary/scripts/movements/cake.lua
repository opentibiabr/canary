local cake = MoveEvent()
cake:type("additem")

function cake.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid == 2918 then
		tileitem:transform(6280)
		moveitem:remove()
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	end
	return true
end

cake:id(6279)
cake:register()

local itemTeleports = MoveEvent()

function itemTeleports.onAddItem(moveitem, tileitem, position)
	local setting = ItemTeleports[tileitem.actionid]
	if not setting then
		return true
	end

	moveitem:moveTo(setting.destination)
	setting.destination:sendMagicEffect(setting.effect)
	return true
end

itemTeleports:type("additem")
itemTeleports:id(1949, 1959)
itemTeleports:register()

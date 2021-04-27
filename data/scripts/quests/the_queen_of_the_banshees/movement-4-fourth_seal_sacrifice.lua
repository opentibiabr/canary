local fourthSealSacrifice = MoveEvent()

function fourthSealSacrifice.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid ~= 2016 or moveitem.type ~= 2 then
		return true
	end

	for i = 1, #fourthSealTable.positions do
		Position(fourthSealTable.positions[i]):sendMagicEffect(CONST_ME_DRAWBLOOD)
	end
	return true
end

fourthSealSacrifice:type("additem")
fourthSealSacrifice:id(426)
fourthSealSacrifice:register()

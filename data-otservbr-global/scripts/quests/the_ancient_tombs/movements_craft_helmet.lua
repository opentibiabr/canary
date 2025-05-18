local helmetIds = { 3236, 3241, 3235, 3239, 3240, 3238, 3237 }

local craftHelmet = MoveEvent()

function craftHelmet.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid == 3030 then
		local tile = Tile(position):getItemById(3229)
		if not tile then
			return true
		end

		tile:transform(3230)
		tile:decay()
		position:sendMagicEffect(CONST_ME_FIREAREA)
		Item(moveitem.uid):remove(1)
		return true
	end

	if not table.contains(helmetIds, moveitem.itemid) then
		return true
	end

	local tile, helmetItems = Tile(position), {}
	local helmetItem
	for i = 1, #helmetIds do
		helmetItem = tile:getItemById(helmetIds[i])
		if not helmetItem then
			return true
		end

		helmetItems[#helmetItems + 1] = helmetItem
	end

	for i = 1, #helmetItems do
		helmetItems[i]:remove()
	end

	Game.createItem(3229, 1, position)
	position:sendMagicEffect(CONST_ME_FIREAREA)
	return true
end

craftHelmet:type("additem")
craftHelmet:aid(40040)
craftHelmet:register()

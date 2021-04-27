local helmetIds = {2335, 2336, 2337, 2338, 2339, 2340, 2341}

local craftHelmet = MoveEvent()

function craftHelmet.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid == 2147 then
		local tile = Tile(position):getItemById(2342)
		if not tile then
			return true
		end

		tile:transform(2343)
		tile:decay()
		position:sendMagicEffect(CONST_ME_FIREAREA)
		Item(moveitem.uid):remove(1)
		return true
	end

	if not isInArray(helmetIds, moveitem.itemid) then
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

	Game.createItem(2342, 1, position)
	position:sendMagicEffect(CONST_ME_FIREAREA)
	return true
end

craftHelmet:type("additem")
craftHelmet:aid(60626)
craftHelmet:register()

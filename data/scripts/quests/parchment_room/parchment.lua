local demonPositions = {
	{x = 33060, y = 31623, z= 15},
	{x = 33066, y = 31623, z= 15},
	{x = 33060, y = 31627, z= 15},
	{x = 33066, y = 31627, z= 15}
}

local function recreateParchment(position)
	local item = Tile(position):getItemById(1953)
	if item then
		item:setActionId(104)
	else
		local parchment = Game.createItem(1953, 1, position)
		if parchment then
			parchment:setText("Buried forever that he never shall return. Don't remove this seal or bad things may happen.")
			parchment:setActionId(104)
		end
	end
end

local parchment = MoveEvent()

function parchment.onRemoveItem(item, tile, position)
	item:removeAttribute(ITEM_ATTRIBUTE_ACTIONID)
	addEvent(recreateParchment, 2 * 60 * 60 * 1000, position) -- 2 hours

	for i = 1, #demonPositions do
		Game.createMonster('Demon', demonPositions[i])
	end
	return true
end

parchment:aid(104)
parchment:register()

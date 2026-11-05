local mechanism = WorldBehavior("world.tile_mechanism", 1)

local function target(context)
	local position = context:relation("target"):getPosition()
	return position and Tile(position), position, context:parameter("targetItem")
end

function mechanism.onStepIn(context, creature, item, position, fromPosition)
	if not creature:getPlayer() then
		return true
	end
	local tile, targetPosition, itemId = target(context)
	local targetItem = tile and tile:getItemById(itemId)
	if targetItem then
		targetItem:remove()
	end
	return true
end

function mechanism.onStepOut(context, creature, item, position, fromPosition)
	if not creature:getPlayer() then
		return true
	end
	local tile, targetPosition, itemId = target(context)
	if tile and not tile:getItemById(itemId) then
		Game.createItem(itemId, 1, targetPosition)
	end
	return true
end

mechanism:register()

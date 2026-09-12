local lever = WorldBehavior("world.lever_remove_item", 1)

function lever.onUse(context, player, item, fromPosition, target, toPosition, isHotkey)
	local first = context:parameter("firstItemId")
	item:transform(item:getId() == first and context:parameter("secondItemId") or first)
	if item:getId() ~= first then
		return true
	end
	local position = context:relation("target"):getPosition()
	local tile = position and Tile(position)
	local obstacle = tile and tile:getItemById(context:parameter("targetItem"))
	if obstacle then
		obstacle:remove()
	end
	return true
end

lever:register()

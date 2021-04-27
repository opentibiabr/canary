local bridgePosition = Position(32851, 32309, 11)
local relocatePosition = Position(32852, 32310, 11)
local dirtIds = {4808, 4810}

local drawbridge = MoveEvent()

function drawbridge.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tile = Tile(bridgePosition)
	local lavaItem = tile:getItemById(598)
	if lavaItem then
		lavaItem:transform(1284)

		local dirtItem
		for i = 1, #dirtIds do
			dirtItem = tile:getItemById(dirtIds[i])
			if dirtItem then
				dirtItem:remove()
			end
		end
	end
	return true
end

drawbridge:type("stepin")
drawbridge:aid(4002)
drawbridge:register()

drawbridge = MoveEvent()

function drawbridge.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tile = Tile(bridgePosition)
	local bridgeItem = tile:getItemById(1284)
	if bridgeItem then
		tile:relocateTo(relocatePosition)
		bridgeItem:transform(598)

		for i = 1, #dirtIds do
			Game.createItem(dirtIds[i], 1, bridgePosition)
		end
	end
	return true
end

drawbridge:type("stepout")
drawbridge:aid(4002)
drawbridge:register()

--[[
This script will remove/create an item when onStepIn/onStepOut on a configurable tile
Just put the variables in the table and it will register everything by itself

Table path: data/startup/tables/tile.lua
]]

local movement = MoveEvent()
movement:type("stepin")

function movement.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = TileUnique[item.uid]
	if not setting then
		return true
	end

	local tile = Tile(setting.targetPos)
	if tile then
	local getItemTile = tile:getItemById(setting.targetItem)
		if getItemTile then
			getItemTile:remove()
		end
	end
	return true
end

for uniqueRange = 29001, 30000 do
	movement:uid(uniqueRange)
end

movement:register()

-- onStepOut
movement = MoveEvent()
movement:type("stepout")

function movement.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local setting = TileUnique[item.uid]
	if not setting then
		return true
	end

	local tile = Tile(setting.targetPos)
	if tile then
	local getItemTile = tile:getItemById(setting.targetItem)
		if not getItemTile then
			Game.createItem(setting.targetItem, 1, setting.targetPos)
		end
	end
	return true
end

for uniqueRange = 29001, 30000 do
	movement:uid(uniqueRange)
end

movement:register()

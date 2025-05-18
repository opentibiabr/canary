local sewerPosition = Position(32482, 32170, 14)

local sewer = MoveEvent()

function sewer.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tile = Tile(sewerPosition)
	if tile then
		local tileItem = tile:getItemById(435)
		if not tileItem then
			Game.createItem(435, 1, sewerPosition)
		end
	end
	return true
end

sewer:type("stepin")
sewer:uid(25030)
sewer:register()

sewer = MoveEvent()

function sewer.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tile = Tile(sewerPosition)
	if tile then
		local tileItem = tile:getItemById(435)
		if tileItem then
			tileItem:remove(1)
		end
	end
	return true
end

sewer:type("stepout")
sewer:uid(25030)
sewer:register()

local stairPosition = {x = 32225, y = 32282, z = 9}

local stair = MoveEvent()
stair:type("stepin")

function stair.onStepIn(creature, item, position, fromPosition)
	-- Create stairs
	if item.uid == 25010 then
		local stairsItem = Tile(stairPosition):getItemById(424)
		if stairsItem then
			stairsItem:transform(8280)
		end
		item:transform(425)
	end
	return true
end

stair:uid(25010)
stair:register()

stair = MoveEvent()
stair:type("stepout")

function stair.onStepOut(creature, item, position, fromPosition)
	local stairsItem = Tile(stairPosition):getItemById(8280)
	if stairsItem then
		stairsItem:transform(424)
	end

	item:transform(426)
	return true
end

stair:uid(25010)
stair:register()

local ladderPosition = {x = 32478, y = 31904, z = 5}

local thirdFloorGhoul = MoveEvent()

function thirdFloorGhoul.onStepIn(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if monster then
		if item.uid == 25017 then
			-- If ghoul step in tile, create the ladder
			item:transform(425)
			Position(ladderPosition):createItem(1386)
			monster:say("<click>")
		end
	end
	return true
end

thirdFloorGhoul:uid(25017)
thirdFloorGhoul:register()

local thirdFloorGhoul = MoveEvent()

function thirdFloorGhoul.onStepOut(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if monster then
		if item.uid == 25017 then
			item:transform(426)
			-- If ghoul step in tile, remove the ladder
			Position(ladderPosition):removeItem(1386)
			monster:say("<click>")
		end
	end
	return true
end

thirdFloorGhoul:uid(25017)
thirdFloorGhoul:register()

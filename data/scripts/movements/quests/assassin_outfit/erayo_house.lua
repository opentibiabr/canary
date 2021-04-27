local enterPosition = Position(32519, 32911, 7)
local exitPosition = Position(32519, 32912, 7)

local erayoHouse = MoveEvent()

function erayoHouse.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not (position == enterPosition) then
		return true
	end

	if not player:getItemById(2202, deepSearch) and not player:getCondition(CONDITION_INVISIBLE) then
		player:teleportTo(exitPosition)
	end

	return true
end

erayoHouse:type("stepin")
erayoHouse:id(3139)
erayoHouse:register()

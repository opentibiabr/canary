local destinations = {
	[2000] = Position(32791, 32331, 10),
	[2001] = Position(32791, 32327, 10)
}

local holyTibleTile = MoveEvent()

function holyTibleTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getItemCount(1970) < 1 then
		player:teleportTo(fromPosition, true)
		return true
	end

	player:teleportTo(destinations[item.uid])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

holyTibleTile:type("stepin")

for index, value in pairs(destinations) do
	holyTibleTile:uid(index)
end

holyTibleTile:register()

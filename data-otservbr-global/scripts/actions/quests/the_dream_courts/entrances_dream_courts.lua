local config = {
	{position = {x = 32042, y = 31938, z = 15}},
	{position = {x = 32043, y = 31938, z = 15}},
	{position = {x = 32042, y = 31939, z = 15}},
	{position = {x = 32043, y = 31939, z = 15}}
}

local entranceDreamCourts = MoveEvent()
function entranceDreamCourts.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(32208, 32093, 13))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

entranceDreamCourts:type("stepin")
for value in pairs(config) do
	entranceDreamCourts:position(config[value].position)
end
entranceDreamCourts:register()
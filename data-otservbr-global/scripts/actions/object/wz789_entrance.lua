local config = {
	{ position = { x = 32600, y = 31866, z = 9 }, destination = { x = 32600, y = 31863, z = 9 } },
	{ position = { x = 32600, y = 31864, z = 9 }, destination = { x = 32600, y = 31867, z = 9 } },
	{ position = { x = 32601, y = 31866, z = 9 }, destination = { x = 32601, y = 31863, z = 9 } },
	{ position = { x = 32601, y = 31864, z = 9 }, destination = { x = 32601, y = 31867, z = 9 } },
}

local moveEvent = MoveEvent()
function moveEvent.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need level 250 to enter.")
		player:teleportTo(fromPosition)
		return true
	end

	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

moveEvent:type("stepin")
for value in pairs(config) do
	moveEvent:position(config[value].position)
end
moveEvent:register()

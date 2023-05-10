local config = {
	{position = {x = 32424, y = 32500, z = 10}, destination = {x = 32405, y = 32497, z = 10}},
	{position = {x = 32405, y = 32498, z = 10}, destination = {x = 32424, y = 32498, z = 10}}
}	
	
local forestOfLife = MoveEvent()
function forestOfLife.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 250 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == player:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

forestOfLife:type("stepin")
for value in pairs(config) do
	forestOfLife:position(config[value].position)
end
forestOfLife:register()
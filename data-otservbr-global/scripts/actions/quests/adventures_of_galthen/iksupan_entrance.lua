local config = {
	{ position = { x = 32728, y = 32875, z = 7 }, destination = { x = 34015, y = 31890, z = 8 } },
}

local entrance = Action()
function entrance.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getLevel() < 150 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 150 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
	for value in pairs(config) do
		if Position(config[value].position) == item:getPosition() then
			player:teleportTo(Position(config[value].destination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

for value in pairs(config) do
	entrance:position(config[value].position)
end
entrance:register()

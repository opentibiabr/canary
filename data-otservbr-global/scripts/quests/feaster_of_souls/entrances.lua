local config = {
	[14515] = {position = Position({x = 31914, y = 32354, z = 8})},
	[14516] = {position = Position({x = 31914, y = 32354, z = 8})},
	[14518] = {position = Position({x = 33613, y = 31415, z = 8})},
	[14519] = {position = Position({x = 33613, y = 31415, z = 8})},
	[14530] = {position = Position({x = 33646, y = 31438, z = 10})},
	[14531] = {position = Position({x = 33646, y = 31438, z = 10})},
	[50701] = {position = Position({x = 33769, y = 31504, z = 13})},
}

local entrances = MoveEvent()

function entrances.onStepIn(creature, item, position, fromPosition)
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
	local data = config[item.actionid]
	if not data then return false end
	doSendMagicEffect(item:getPosition(), CONST_ME_TELEPORT)
	player:teleportTo(data.position)
	doSendMagicEffect(data.position, CONST_ME_TELEPORT)		
	return true
end

entrances:type("stepin")

for index, value in pairs(config) do
	entrances:aid(index)
end

entrances:register()
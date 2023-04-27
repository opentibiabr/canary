local config = {
	[50700] = {position = Position({x = 33775, y = 31505, z = 13})}
}

local entrances = MoveEvent()
local itemId = 32703
local itemAmount = 2

function entrances.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getItemCount(itemId) >= itemAmount then
		player:removeItem(itemId, itemAmount)
		else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need 2 death tolls to enter.")
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
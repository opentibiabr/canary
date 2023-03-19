local config = {
	{position = {x = 33137, y = 32352, z = 5}, destination = {x = 33117, y = 32252, z = 10}},
	{position = {x = 33116, y = 32252, z = 10}, destination = {x = 33138, y = 32353, z = 5}},
	{position = {x = 33092, y = 32314, z = 11}, destination = {x = 33090, y = 32280, z = 12}},
	{position = {x = 33090, y = 32279, z = 12}, destination = {x = 33092, y = 32315, z = 11}}
}

local entranceAncientFeud = Action()
function entranceAncientFeud.onUse(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getStorageValue(Storage.Quest.U10_80.Grimvale.AncientFeudShortcut) < 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not worthy to travel by the lion's roar.")
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
	entranceAncientFeud:position(config[value].position)
end
entranceAncientFeud:register()

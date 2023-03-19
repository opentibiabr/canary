local positions = {
    {position = {x = 32962, y = 31497, z = 7}, destination = {x = 33647, y = 31438, z = 10}}, -- entrance vengoth
    {position = {x = 32963, y = 31497, z = 7}, destination = {x = 33647, y = 31438, z = 10}},
	{position = {x = 32883, y = 32518, z = 7}, destination = {x = 33613, y = 31415, z = 8}}, -- entrance port hope
	{position = {x = 32884, y = 32518, z = 7}, destination = {x = 33613, y = 31415, z = 8}},
	{position = {x = 32625, y = 32076, z = 7}, destination = {x = 31914, y = 32354, z = 8}}, -- entrance jakundaf
	{position = {x = 32626, y = 32076, z = 7}, destination = {x = 31914, y = 32354, z = 8}}
}

local feasterEntrances = MoveEvent()
function feasterEntrances.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end
	if player:getLevel() < 250 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need at least level 250 to enter.")
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return false
	end
    for index, value in pairs(positions) do
        if Tile(position) == Tile(value.position) then
            player:teleportTo(value.destination)
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        end
    end
    return true
end
for index, value in pairs(positions) do
    feasterEntrances:position(value.position)
end

feasterEntrances:register()
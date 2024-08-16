local positions = {
	{ position = { x = 32962, y = 31497, z = 7 }, destination = { x = 33647, y = 31438, z = 10 } }, -- entrance vengoth
	{ position = { x = 32963, y = 31497, z = 7 }, destination = { x = 33647, y = 31438, z = 10 } },
	{ position = { x = 32883, y = 32518, z = 7 }, destination = { x = 33613, y = 31415, z = 8 } }, -- entrance port hope
	{ position = { x = 32884, y = 32518, z = 7 }, destination = { x = 33613, y = 31415, z = 8 } },
	{ position = { x = 32625, y = 32076, z = 7 }, destination = { x = 31914, y = 32354, z = 8 } }, -- entrance jakundaf
	{ position = { x = 32626, y = 32076, z = 7 }, destination = { x = 31914, y = 32354, z = 8 } },
	{ position = { x = 33863, y = 31854, z = 9 }, destination = { x = 33602, y = 31443, z = 10 } }, -- edron to vengoth
	{ position = { x = 33601, y = 31441, z = 10 }, destination = { x = 33861, y = 31855, z = 9 } }, --  vengoth to edron
	{ position = { x = 31904, y = 32346, z = 9 }, destination = { x = 33573, y = 31461, z = 8 } }, --  jakundaf to banuta
	{ position = { x = 33572, y = 31459, z = 8 }, destination = { x = 31904, y = 32348, z = 9 } }, --  banuta to jakundaf
	{ position = { x = 33581, y = 31465, z = 9 }, destination = { x = 33887, y = 31786, z = 8 } }, --  banuta to edron
	{ position = { x = 33886, y = 31784, z = 8 }, destination = { x = 33581, y = 31466, z = 9 } }, --  edron to banuta
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

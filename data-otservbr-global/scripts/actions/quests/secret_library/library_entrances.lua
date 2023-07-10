local config = {
	{position = {x = 32616, y = 32529, z = 13}, destination = {x = 32719, y = 32770, z = 10}}, -- mazzinor
	{position = {x = 32718, y = 32768, z = 10}, destination = {x = 32616, y = 32531, z = 13}},
	{position = {x = 32724, y = 32728, z = 10}, destination = {x = 32616, y = 32531, z = 13}},
	{position = {x = 32660, y = 32736, z = 12}, destination = {x = 32745, y = 32746, z = 10}}, -- gorzindel
	{position = {x = 32744, y = 32744, z = 10}, destination = {x = 32660, y = 32734, z = 12}},
	{position = {x = 32687, y = 32726, z = 10}, destination = {x = 32660, y = 32734, z = 12}},
	{position = {x = 32662, y = 32713, z = 13}, destination = {x = 32745, y = 32770, z = 10}}, -- ghulosh
	{position = {x = 32744, y = 32768, z = 10}, destination = {x = 32660, y = 32713, z = 13}},
	{position = {x = 32755, y = 32729, z = 10}, destination = {x = 32660, y = 32713, z = 13}},
	{position = {x = 32464, y = 32654, z = 12}, destination = {x = 32719, y = 32746, z = 10}}, -- lokathmor
	{position = {x = 32718, y = 32744, z = 10}, destination = {x = 32466, y = 32654, z = 12}},
	{position = {x = 32750, y = 32696, z = 10}, destination = {x = 32466, y = 32654, z = 12}},
	{position = {x = 32480, y = 32601, z = 15}, destination = {x = 32673, y = 32738, z = 11}}, -- scourge of oblivion
	{position = {x = 32672, y = 32736, z = 11}, destination = {x = 32480, y = 32599, z = 15}},
	{position = {x = 32726, y = 32748, z = 11}, destination = {x = 32480, y = 32599, z = 15}}	
	}

local libraryEntrances = MoveEvent()
function libraryEntrances.onStepIn(creature, item, position, fromPosition)
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

for value in pairs(config) do
	libraryEntrances:position(config[value].position)
end
libraryEntrances:register()
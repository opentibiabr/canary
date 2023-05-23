local setting = {
	-- Nibelor 5: Cure the Dogs needed or Barbarian Test Quest needed
	{
		sledPosition = Position(32367, 31058, 7),
		destination = Position(32407, 31067, 7),
		storage = Storage.TheIceIslands.Mission06,
		value = 8
	},
	{
		sledPosition = Position(32409, 31066, 7),
		destination = Position(32365, 31059, 7),
		storage = Storage.TheIceIslands.Mission06,
		value = 8
	},
	{
		sledPosition = Position(32303, 31081, 7),
		destination = Position(32329, 31045, 7),
		storage = Storage.TheIceIslands.Mission03,
		value = 3
	},
	{
		sledPosition = Position(32327, 31045, 7),
		destination = Position(32301, 31080, 7),
		storage = Storage.TheIceIslands.Mission03,
		value = 3
	}
}

local nibelorDogLed = MoveEvent()

function nibelorDogLed.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	for b = 1, #setting do
		if player:getPosition() == setting[b].sledPosition then
			if player:getStorageValue(setting[b].storage) == setting[b].value and player:removeItem(3582, 1) then
				player:teleportTo(setting[b].destination)
				setting[b].destination:sendMagicEffect(CONST_ME_TELEPORT)
			else
				player:teleportTo(fromPosition)
			end
		end
	end
	return true
end

for a = 1, #setting do
	nibelorDogLed:position({x = setting[a].sledPosition.x, y = setting[a].sledPosition.y, z = 7})
end
nibelorDogLed:register()

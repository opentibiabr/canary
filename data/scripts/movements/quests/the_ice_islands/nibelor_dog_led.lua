local setting = {
	-- Nibelor 5: Cure the Dogs needed or Barbarian Test Quest needed
	[12025] = {
		destination = Position(32407, 31067, 7),
		storage = Storage.TheIceIslands.Mission06,
		value = 8
	},
	[12026] = {
		destination = Position(32365, 31059, 7),
		storage = Storage.TheIceIslands.Mission06,
		value = 8
	},
	[12027] = {
		destination = Position(32329, 31045, 7),
		storage = Storage.TheIceIslands.Mission03,
		value = 3
	},
	[12028] = {
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

	local sled = setting[item.uid]
	if not sled then
		return true
	end

	if player:getStorageValue(sled.storage) == sled.value and player:removeItem(2671, 1) then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(sled.destination)
		sled.destination:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

nibelorDogLed:type("stepin")
nibelorDogLed:uid(1057, 1058, 1059, 1060)
nibelorDogLed:register()

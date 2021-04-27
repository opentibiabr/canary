local sacrificeTeleport = MoveEvent()

function sacrificeTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.SanctuaryOfTheLizardGod.LizardGodTeleport) == 1 then
		player:teleportTo({x = 32124, y = 31938, z = 8})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Offer the lives of the yet unborn to the lizard god if you want to enter the sanctuary.")
	end
	return true
end

sacrificeTeleport:uid(35010)
sacrificeTeleport:register()

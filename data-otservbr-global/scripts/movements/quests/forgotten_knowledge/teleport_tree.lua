local teleportTree = MoveEvent()

function teleportTree.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	if player:getStorageValue(Storage.ForgottenKnowledge.PlantCounter) < 5
	or player:getStorageValue(Storage.ForgottenKnowledge.BirdCounter) < 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't help in anything to enter here")
		player:teleportTo(Position(32737, 32117, 10))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:setDirection(SOUTH)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	player:teleportTo(Position(32720, 32927, 14))
	player:getPosition():sendMagicEffect(CONST_ME_SMALLPLANTS)
	return true
end

teleportTree:type("stepin")
teleportTree:aid(27830)
teleportTree:register()

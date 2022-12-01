local failPosition = Position(32092, 32177, 6)

local levelBridge = MoveEvent()

function levelBridge.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getLevel() >= 2 then
		return true
	end

	player:teleportTo(failPosition)
	failPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need to be at least Level 2 in order to pass.')
	return true
end

levelBridge:type("stepin")
levelBridge:aid(50998)
levelBridge:register()

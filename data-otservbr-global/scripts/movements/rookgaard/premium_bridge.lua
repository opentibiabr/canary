local failPosition = Position(32066, 32192, 7)

local premiumBridge = MoveEvent()

function premiumBridge.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:isPremium() then
		return true
	end

	failPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:teleportTo(failPosition)
	return true
end

premiumBridge:type("stepin")
premiumBridge:aid(50241)
premiumBridge:register()

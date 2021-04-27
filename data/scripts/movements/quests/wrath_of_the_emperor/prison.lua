local prison = MoveEvent()

function prison.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player or player:getStorageValue(Storage.WrathoftheEmperor.PrisonReleaseStatus) ~= 1 then
		return true
	end

	if player:getCondition(CONDITION_OUTFIT) then
		player:removeCondition(CONDITION_OUTFIT)
	end

	player:setStorageValue(Storage.WrathoftheEmperor.PrisonReleaseStatus, 0)

	local destination = Position(33363, 31188, 8)
	player:teleportTo(destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

prison:type("stepin")
prison:uid(3175)
prison:register()

local prison = MoveEvent()

function prison.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player or player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.PrisonReleaseStatus) ~= 1 then
		return true
	end

	if player:getCondition(CONDITION_OUTFIT) then
		player:removeCondition(CONDITION_OUTFIT)
	end

	player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.PrisonReleaseStatus, 0)
	player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.GuardcaughtYou, -1)
	local destination = Position(33359, 31183, 8)
	player:teleportTo(destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 2 then
		player:addItem(11328)
	end
	return true
end

prison:type("stepin")
prison:position({ x = 33362, y = 31202, z = 8 })
prison:register()

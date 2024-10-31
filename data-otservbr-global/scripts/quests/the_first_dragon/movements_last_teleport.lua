local lastTeleport = MoveEvent()

local function isDateWithinEvent()
	local currentDate = os.date("*t")
	local startDate = { day = 14, month = 1 }
	local endDate = { day = 12, month = 2 }

	if (currentDate.month == startDate.month and currentDate.day >= startDate.day) or (currentDate.month == endDate.month and currentDate.day <= endDate.day) or (currentDate.month > startDate.month and currentDate.month < endDate.month) then
		return true
	end
	return false
end

function lastTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local destination = { x = 33585, y = 30990, z = 14 }

	if not isDateWithinEvent() then
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This teleport is only available between January 14 and February 12.")
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.FirstDragonTimer) < os.time() then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait to challenge The First Dragon again!")
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

lastTeleport:uid(24889)
lastTeleport:register()

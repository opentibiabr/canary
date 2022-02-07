local exerciseTraining = Action()

function exerciseTraining.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerId = player:getId()
	local targetId = target:getId()

	if target:isItem() and (isInArray(houseDummies, targetId) or isInArray(freeDummies, targetId)) then
		if onExerciseTraining[playerId] then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This exercise dummy can only be used after a 30 second cooldown.")
			leaveTraining(playerId)
			return true
		end

		local playerPos = player:getPosition()
		if not exerciseWeaponsTable[item.itemid].allowFarUse and (playerPos:getDistance(target:getPosition()) > 1) then
			player:sendTextMessage(MESSAGE_FAILURE, "Get closer to the dummy.")
			return true
		end

		if not getTilePzInfo(playerPos) then
			player:sendTextMessage(MESSAGE_FAILURE, "You need to be in a protection zone.")
			return true
		end

		local targetPos = target:getPosition()

		if isInArray(houseDummies, targetId) then
			local playersOnDummy = 0
			for _, playerTraining in pairs(onExerciseTraining) do
				if playerTraining.dummyPos == targetPos then
					playersOnDummy = playersOnDummy + 1
				end

				if playersOnDummy == maxAllowedOnADummy then
					player:sendTextMessage(MESSAGE_FAILURE, "That exercise dummy is busy.")
					return true
				end
			end
		end

		if player:getStorageValue(Storage.isTraining) > os.time() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This exercise dummy can only be used after a 30 second cooldown.")
			return true
		end

		onExerciseTraining[playerId] = {}
		if not onExerciseTraining[playerId].event then
			onExerciseTraining[playerId].event = addEvent(exerciseEvent, 0, playerId, targetPos, item.itemid, targetId)
			onExerciseTraining[playerId].dummyPos = targetPos
			player:setTraining(true)
			player:setStorageValue(Storage.isTraining, os.time() + 30)
		end
		return true
	end
	return false
end

for weaponId, weapon in pairs(exerciseWeaponsTable) do
	exerciseTraining:id(weaponId)
	if weapon.allowFarUse then
		exerciseTraining:allowFarUse(true)
	end
end

exerciseTraining:register()
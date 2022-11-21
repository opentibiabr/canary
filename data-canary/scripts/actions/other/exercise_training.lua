local exerciseTraining = Action()

function exerciseTraining.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerId = player:getId()
	local targetId = target:getId()

	if target:isItem() and (table.contains(HouseDummies, targetId) or table.contains(FreeDummies, targetId)) then
		if onExerciseTraining[playerId] then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This exercise dummy can only be used after a 30 second cooldown.")
			LeaveTraining(playerId)
			return true
		end

		local playerPos = player:getPosition()
		if not ExerciseWeaponsTable[item.itemid].allowFarUse and (playerPos:getDistance(target:getPosition()) > 1) then
			player:sendTextMessage(MESSAGE_FAILURE, "Get closer to the dummy.")
			return true
		end

		if not playerPos:isProtectionZoneTile() then
			player:sendTextMessage(MESSAGE_FAILURE, "You need to be in a protection zone.")
			return true
		end

		local targetPos = target:getPosition()

		if table.contains(HouseDummies, targetId) then
			local playersOnDummy = 0
			for _, playerTraining in pairs(onExerciseTraining) do
				if playerTraining.dummyPos == targetPos then
					playersOnDummy = playersOnDummy + 1
				end

				if playersOnDummy == MaxAllowedOnADummy then
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
			onExerciseTraining[playerId].event = addEvent(ExerciseEvent, 0, playerId, targetPos, item.itemid, targetId)
			onExerciseTraining[playerId].dummyPos = targetPos
			player:setTraining(true)
			player:setStorageValue(Storage.isTraining, os.time() + 30)
		end
		return true
	end
	return false
end

for weaponId, weapon in pairs(ExerciseWeaponsTable) do
	exerciseTraining:id(weaponId)
	if weapon.allowFarUse then
		exerciseTraining:allowFarUse(true)
	end
end

exerciseTraining:register()
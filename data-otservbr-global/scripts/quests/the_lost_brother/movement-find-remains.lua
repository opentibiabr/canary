local findRemains = MoveEvent()

function findRemains.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You stumble over some old bones. Something is carved into the stone wall here: 'Tarun, my brother, you were right. She's evil.'")
		player:setStorageValue(Storage.Quest.U10_80.TheLostBrotherQuest, 2)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end

	return true
end

findRemains:position(Position(32959, 32674, 4))
findRemains:register()

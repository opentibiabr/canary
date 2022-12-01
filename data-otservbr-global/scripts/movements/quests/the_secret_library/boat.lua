local boat = MoveEvent()

function boat.onStepIn(creature, item, toPosition, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.TheSecretLibrary.HighDry) == 1 then
		player:setStorageValue(Storage.TheSecretLibrary.HighDry, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"There are still some loose planks and hawsers. You can\'t use the raft like this, it will sink for sure.")
	end
	return true
end

boat:aid(26701)
boat:register()

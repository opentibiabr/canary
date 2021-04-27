local rewardRoomText = MoveEvent()

function rewardRoomText.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player or player:getStorageValue(Storage.TheInquisition.RewardRoomText) == 1 then
		return true
	end

	player:setStorageValue(Storage.TheInquisition.RewardRoomText, 1)
	player:say("You can choose exactly one of these chets. Choose wisely!", TALKTYPE_MONSTER_SAY, false, player)
	return true
end

rewardRoomText:type("stepin")
rewardRoomText:aid(4003)
rewardRoomText:register()

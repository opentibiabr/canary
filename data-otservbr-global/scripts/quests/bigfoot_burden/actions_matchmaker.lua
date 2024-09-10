local bigfootMatch = Action()
function bigfootMatch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid < 15809 and target.itemid > 15815 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.MatchmakerStatus) == 1 or player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.MissionMatchmaker) ~= 1 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.MatchmakerIdNeeded) ~= target.itemid then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This is not the crystal you're looking for!")
		return true
	end

	player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.MatchmakerStatus, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! The crystals seem to have fallen in love and your mission is done!")
	toPosition:sendMagicEffect(CONST_ME_HEARTS)
	item:remove()
	return true
end

bigfootMatch:id(15801)
bigfootMatch:register()

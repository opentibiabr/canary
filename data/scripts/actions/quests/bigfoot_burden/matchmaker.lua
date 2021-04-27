local bigfootMatch = Action()
function bigfootMatch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid < 18320 and target.itemid > 18326 then
		return false
	end

	if player:getStorageValue(Storage.BigfootBurden.MatchmakerStatus) == 1 or player:getStorageValue(Storage.BigfootBurden.MissionMatchmaker) ~= 1 then
		return false
	end

	if player:getStorageValue(Storage.BigfootBurden.MatchmakerIdNeeded) ~= target.itemid then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is not the crystal you\'re looking for!')
		return true
	end

	player:setStorageValue(Storage.BigfootBurden.MatchmakerStatus, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Congratulations! The crystals seem to have fallen in love and your mission is done!')
	toPosition:sendMagicEffect(CONST_ME_HEARTS)
	item:remove()
	return true
end

bigfootMatch:id(18312)
bigfootMatch:register()
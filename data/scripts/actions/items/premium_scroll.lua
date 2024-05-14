local Premium_scroll = Action()

function Premium_scroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local owner_id = item:getOwnerId()
	if not owner_id then
		return false
	end
	if player:getXpBoostTime() > 0 then
		player:sendTextMessage(MESSAGE_LOOK, "You already have an active XP boost.")
		return false
	else
		local playerUid = player:getGuid()
		logScroll(player, owner_id, " Player id: " .. playerUid .. " used scroll from player id: " .. owner_id)
		item:remove()
		GameStore.processExpBoostPurchase(player)
		player:sendTextMessage(MESSAGE_LOOK, "You used a premium EXP scroll.")
		return true
	end
	return false
end

Premium_scroll:id(14758)
Premium_scroll:register()

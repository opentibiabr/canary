local premiumScroll = Action()

function premiumScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local days = 7
	item:remove(1)
	player:addPremiumDays(days)
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		player:onAddVip(days)
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have activated your " .. days .. " days vip time, log in again to make it effective.")
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

premiumScroll:id(14758)
premiumScroll:register()

local playerLogin = CreatureEvent("VipLogin")

function playerLogin.onLogin(player)
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		local wasVip = player:getStorageValue(Storage.VipSystem.IsVip) == 1
		if wasVip and not player:isVip() then player:onRemoveVip() end
		if not wasVip and player:isVip() then player:onAddVip(player:getVipDays()) end

		if player:isVip() then
			if (player:getVipDays() == 0xFFFF) then
				player:sendTextMessage(MESSAGE_LOGIN, 'You have infinite amount of VIP days left.')
				return true
			end

			local timeRemaining = player:getVipTime() - os.time()
			local days = math.floor(timeRemaining / 86400)
			if days > 1 then
				player:sendTextMessage(MESSAGE_LOGIN, string.format("You have %d VIP days left.", days))
				return true
			end

			local hours = math.floor((timeRemaining % 86400) / 3600)
			local minutes = math.floor((timeRemaining % 3600) / 60)
			local seconds = timeRemaining % 60
			player:sendTextMessage(MESSAGE_LOGIN, string.format("You have %d hours, %d minutes and %d seconds VIP days left.", hours, minutes, seconds))
		end
	end
	return true
end

playerLogin:register()

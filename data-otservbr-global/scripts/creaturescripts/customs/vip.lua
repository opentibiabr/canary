local playerLogin = CreatureEvent("VipLogin")

function playerLogin.onLogin(player)
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		local wasVip = player:getStorageValue(Storage.VipSystem.IsVip) == 1
		if wasVip and not player:isVip() then player:onRemoveVip() end
		if not wasVip and player:isVip() then player:onAddVip(player:getVipDays()) end
		if player:isVip() then
			local days = player:getVipDays()
			player:sendTextMessage(MESSAGE_LOGIN, string.format('You have %s VIP day%s left.', (days == 0xFFFF and 'infinite amount of' or days), (days == 1 and '' or 's')))
		end
	end
	return true
end

playerLogin:register()

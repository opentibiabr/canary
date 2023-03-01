local config = {
	storage = tonumber(Storage.VipSystem.VipGainTibiaCoins),
	checkDuplicateIps = true,
	showMsgToFree = true,
	vipCoins = 1, -- amount of coins, players will win
}

local onlineCoinsEvent = GlobalEvent("GainCoinPerHour")

function onlineCoinsEvent.onThink(interval)
	if (not configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED)
		or not configManager.getBoolean(configKeys.VIP_SYSTEM_GAIN_COINS_ENABLED)) then
		return false
	end

	local players = Game.getPlayers()
	if #players == 0 then
		return true
	end

	local checkIp = {}
	for _, player in pairs(players) do
		local ip = player:getIp()
		if ip ~= 0 and (not config.checkDuplicateIps or not checkIp[ip]) then
			checkIp[ip] = true
			local seconds = math.max(0, player:getStorageValue(config.storage))
			if seconds >= 3600 then

				if player:getAccountType() >= ACCOUNT_TYPE_GAMEMASTER then
					return true
				end

				if not player:isVip() and config.showMsgToFree then
					player:sendTextMessage(MESSAGE_EVENT_DEFAULT, "You don't have a VIP to receive your coins ")
				elseif player:isVip() then
					player:addTibiaCoins(config.vipCoins, true)
					player:sendTextMessage(MESSAGE_EVENT_DEFAULT,
						string.format("Congratulations %s!\z You have received %d %s for being online and being VIP.", player:getName(), config.vipCoins, "tibia coins")
					)
				end

				player:setStorageValue(config.storage, 0)
				return true
			end
			player:setStorageValue(config.storage, seconds + math.ceil(interval / 1000))
		end
	end
	return true
end

onlineCoinsEvent:interval(10000)
onlineCoinsEvent:register()

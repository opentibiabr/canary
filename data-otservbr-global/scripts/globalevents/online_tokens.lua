local config = {
	storage = tonumber(Storage.VipSystem.GainTokens),
	checkDuplicateIps = true,
	tokenItemId = 14112, -- bar of gold
	tokensPerHour = 2, -- amount of tokens, players free will win
	tokensPerHourVip = 5 -- amount of tokens, players vip will win
}

local onlineTokensEvent = GlobalEvent("GainTokenPerHour")

function onlineTokensEvent.onThink(interval)
	if (not configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED)
		or not configManager.getBoolean(configKeys.VIP_SYSTEM_GAIN_TOKENS_ENABLED)) then
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

				local tokensToWin = (player:isVip() and config.tokensPerHourVip) or config.tokensPerHour
				if tokensToWin > 0 then
					player:setStorageValue(config.storage, 0)
					local item = player:addItem(config.tokenItemId, tokensToWin)
					if item then
						player:sendTextMessage(MESSAGE_EVENT_DEFAULT,
							string.format("Congratulations %s!\z You have received %d %s for being online%s.", player:getName(), tokensToWin, "tokens", (player:isVip() and " and being VIP") or "")
						)
					end
				end

				return true
			end
			player:setStorageValue(config.storage, seconds + math.ceil(interval / 1000))
		end
	end
	return true
end

onlineTokensEvent:interval(10000)
onlineTokensEvent:register()

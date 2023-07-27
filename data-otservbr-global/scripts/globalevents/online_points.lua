local config = {
	enabled = false,
	storage = Storage.VipSystem.OnlineCoinsGain,
	checkDuplicateIps = false,

	interval = 60 * 1000,

	-- per hour | system will calculate how many coins will be given and when
	coinsPerHour = {
		free = 50,
		vip = 100,
	},

	awardOn = 50,
}

local onlineCoinsEvent = GlobalEvent("GainCoinInterval")
local runsPerHour = 3600 / (config.interval / 1000)

local function coinsPerRun(coinsPerHour)
	return coinsPerHour / runsPerHour
end

function onlineCoinsEvent.onThink(interval)
	local players = Game.getPlayers()
	if #players == 0 then
		return true
	end

	local checkIp = {}
	for _, player in pairs(players) do
		local ip = player:getIp()
		if ip ~= 0 and (not config.checkDuplicateIps or not checkIp[ip]) then
			checkIp[ip] = true
			local remainder = math.max(0, player:getStorageValue(config.storage)) / 10000000
			local coins = coinsPerRun(player:isVip() and config.coinsPerHour.vip or config.coinsPerHour.free) + remainder
			player:setStorageValue(config.storage, coins * 10000000)
			if coins >= config.awardOn then
				player:addTibiaCoins(math.floor(coins), true)
				player:sendTextMessage(MESSAGE_STATUS_SMALL, "You have received " .. math.floor(coins) .. " online points.")
				player:setStorageValue(config.storage, (coins - math.floor(coins)) * 10000000)
			end
		end
	end
	return true
end

if config.enabled then
	onlineCoinsEvent:interval(config.interval)
	onlineCoinsEvent:register()
end

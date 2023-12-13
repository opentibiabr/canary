local config = {
	enabled = false,
	storage = Storage.VipSystem.OnlineCoinsGain,
	checkDuplicateIps = false,

	interval = 60 * 1000,

	-- per hour | system will calculate how many coins will be given and when
	-- put 0 in coinsPerHour.free to disable free from receiving coins
	coinsPerHour = {
		free = 1,
		vip = 5,
	},

	-- system will distribute when the player accumulate x coins
	awardOn = 5,
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
		if player:getGroup():getId() > GROUP_TYPE_SENIORTUTOR or (config.coinsPerHour.free < 1 and not player:isVip()) then
			goto continue
		end

		local ip = player:getIp()
		if ip ~= 0 and (not config.checkDuplicateIps or not checkIp[ip]) then
			checkIp[ip] = true
			local remainder = math.max(0, player:getStorageValue(config.storage)) / 10000000
			local coins = coinsPerRun(player:isVip() and config.coinsPerHour.vip or config.coinsPerHour.free) + remainder
			player:setStorageValue(config.storage, coins * 10000000)
			if coins >= config.awardOn then
				local coinsMath = math.floor(coins)
				player:addTibiaCoins(coinsMath, true)
				player:sendTextMessage(MESSAGE_FAILURE, string.format("Congratulations %s!\z You have received %d %s for being online.", player:getName(), coinsMath, "tibia coins"))
				player:setStorageValue(config.storage, (coins - coinsMath) * 10000000)
			end
		end

		::continue::
	end
	return true
end

if config.enabled then
	onlineCoinsEvent:interval(config.interval)
	onlineCoinsEvent:register()
end

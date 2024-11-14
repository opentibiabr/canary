local config = {
	enabled = true,
	storage = Storage.VipSystem.OnlineCoinsGain,
	checkDuplicateIps = true,
	enableGods = true,

	interval = 1 * 1000, -- horas * 1000

	-- per hour | system will calculate how many coins will be given and when
	-- put 0 in coinsPerHour.free to disable free from receiving coins
	coinsPerHour = {
		free = 5,
		vip = 10,
	},

	-- system will distribute when the player accumulate x coins
	awardOn = 30,
}

local onlineCoinsEvent = GlobalEvent("GainCoinInterval")
local runsPerHour = 3600 / (config.interval / 1000) -- 60 * minutos de intervalo, next caso 60 * 60 = 3600

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
		--if player:getGroup():getId() > GROUP_TYPE_SENIORTUTOR or (config.coinsPerHour.free < 1 and not player:isVip()) then
		if not config.enableGods and (player:getGroup():getId() > GROUP_TYPE_SENIORTUTOR) or (config.coinsPerHour.free < 1 and not player:isVip()) then
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
				player:addTransferableCoins(coinsMath, true)
				--player:sendColoredMessage("{yellow|[ROULETTE WINNER]} Congratulations! You have won a {blue|rare item} and {green|5000 gold}.")
				player:sendColoredMessage(string.format("{purple|[ONLINE REWARD]} Congratulations %s! You received {purple|%d} %s for being online.", player:getName(), coinsMath, "tibia coins"))
				db.query(string.format("INSERT INTO `store_history`(`account_id`, `mode`, `description`, `coin_type`, `coin_amount`, `time`) VALUES (%s, %s, %s, %s, %s, %s)", player:getAccountId(), "0", db.escapeString("[ONLINE REWARD] - Reward"), "1", coinsMath, os.time()))
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

-----------------------------------------------------------------------

local onlineCoinsLogout = CreatureEvent("onlineCoinsLogout")

function onlineCoinsLogout.onLogout(player)
	local playerId = player:getId()

	player:setStorageValue(config.storage, 0)

	return true
end

onlineCoinsLogout:register()

------------------------------------------------------------------------

local onlineCoinsOnStartup = GlobalEvent("onlineCoinsOnStartup")
function onlineCoinsOnStartup.onStartup()
		--db.query("UPDATE `players` SET `posx` = 0, `posy` = 0, `posz` = 0;")
		local exec = db.query(string.format("UPDATE `player_storage` SET `value` = %d WHERE `key` = %d", 0, config.storage))
		if exec then
			logger.info("[Online Reward] - Players Storage cleaned succesfully.")
		else
			logger.error("[Online Reward] - Players Storage problem to be cleaned. Check data-otservbr-global/scripts/globalevents/vip/online_coins.lua")
		end
	return true
end

onlineCoinsOnStartup:register()

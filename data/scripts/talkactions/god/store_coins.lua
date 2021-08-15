-- /getcoins playername
-- /addcoins playername, coinscount, example: "/addcoins god, 100"
-- /removecoins playername, coinscount, example: "/removecoins god, 100"

local getCoins = TalkAction("/getcoins")

function getCoins.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		Spdlog.error("[getCoins.onSay] - Player name param not found")
		return false
	end

	local split = param:split(",")
	-- Check if player is online
	local targetPlayer = Player(split[1])
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(split[1]) .." is not online")
		Spdlog.error("[getCoins.onSay] - Player ".. string.titleCase(split[1]) .." is not online")
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player ".. targetPlayer:getName() .." have ".. targetPlayer:getStoreCoins(COIN_TYPE_DEFAULT) .." store coins.")
	return true
end

getCoins:separator(" ")
getCoins:register()

local addCoins = TalkAction("/addcoins")

function addCoins.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		Spdlog.error("[addCoins.onSay] - Player name param not found")
		return false
	end

	local split = param:split(",")
	-- Check if have all parameters (god and coinscount)
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters")
		Spdlog.error("[addCoins.onSay] - Insufficient parameters")
		return false
	end

	-- Check if player is online
	local targetPlayer = Player(split[1])
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(split[1]) .." is not online")
		Spdlog.error("[addCoins.onSay] - Player ".. string.titleCase(split[1]) .." is not online")
		return false
	end

	-- Trim left
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")

	-- Keep the coinscount in storage "coins"
	local coins = 0
	if split[2] then
		coins = tonumber(split[2])
	end

	-- Check if the coins is valid
	if coins <= 0 or coins == nil then
		player:sendCancelMessage("Invalid coins count.")
		return false
	end

	targetPlayer:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	targetPlayer:addStoreCoins(coins, COIN_TYPE_DEFAULT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfull added ".. coins .." store coins for the ".. targetPlayer:getName() .." account.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." added ".. coins .." store coins to your account.")
	-- Distro log
	Spdlog.info("".. player:getName() .." added ".. coins .." store coins to ".. targetPlayer:getName() .." account.")
	return true
end

addCoins:separator(" ")
addCoins:register()

local removeCoins = TalkAction("/removecoins")

function removeCoins.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		Spdlog.error("[removeCoins.onSay] - Player name param not found")
		return false
	end

	local split = param:split(",")
	-- Check if have all parameters (god and coinscount)
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters")
		Spdlog.error("[removeCoins.onSay] - Insufficient parameters")
		return false
	end

	-- Check if player is online
	local targetPlayer = Player(split[1])
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(split[1]) .." is not online")
		Spdlog.error("[removeCoins.onSay] - Player ".. string.titleCase(split[1]) .." is not online")
		return false
	end

	-- Trim left
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")

	-- Keep the coinscount in storage "coins"
	local coins = 0
	if split[2] then
		coins = tonumber(split[2])
	end

	-- Check if the coins is valid
	if coins <= 0 or coins == nil then
		player:sendCancelMessage("Invalid coins count.")
		return false
	end

	targetPlayer:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	targetPlayer:removeStoreCoins(coins, COIN_TYPE_DEFAULT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfull removed ".. coins .." store coins for the ".. targetPlayer:getName() .." account.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." removed ".. coins .." store coins to your account.")
	-- Distro log
	Spdlog.info("".. player:getName() .." removed ".. coins .." store coins to ".. targetPlayer:getName() .." account.")
	return true
end

removeCoins:separator(" ")
removeCoins:register()

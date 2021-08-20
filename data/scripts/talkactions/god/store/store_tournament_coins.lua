-- /gettournamentcoins playername
-- /addtournamentcoins playername, coinscount, example: "/addtournamentcoins god, 100"
-- /removetournamentcoins playername, coinscount, example: "/removetournamentcoins god, 100"

local getTournamentCoins = TalkAction("/gettournamentcoins")

function getTournamentCoins.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		-- Distro log
		Spdlog.error("[getTournamentCoins.onSay] - Player name param not found")
		return false
	end

	local split = param:split(",")
	-- Check if player is online
	local targetPlayer = Player(split[1])
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(split[1]) .." is not online")
		-- Distro log
		Spdlog.error("[getTournamentCoins.onSay] - Player ".. string.titleCase(split[1]) .." is not online")
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player ".. targetPlayer:getName() .." \z
                           have ".. targetPlayer:getStoreCoins(COIN_TYPE_TOURNAMENT) .." store tournament coins.")
	return true
end

getTournamentCoins:separator(" ")
getTournamentCoins:register()

local addTournamentCoins = TalkAction("/addTournamentCoins")

function addTournamentCoins.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		-- Distro log
		Spdlog.error("[addTournamentCoins.onSay] - Player name param not found")
		return false
	end

	local split = param:split(",")
	-- Check if have all parameters (god and coinscount)
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters")
		-- Distro log
		Spdlog.error("[addTournamentCoins.onSay] - Insufficient parameters")
		return false
	end

	-- Check if player is online
	local targetPlayer = Player(split[1])
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(split[1]) .." is not online")
		-- Distro log
		Spdlog.error("[addTournamentCoins.onSay] - Player ".. string.titleCase(split[1]) .." is not online")
		return false
	end

	-- Trim left
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")

	-- Keep the coinscount in variable "coins"
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
	targetPlayer:addStoreCoins(coins, COIN_TYPE_TOURNAMENT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfull added ".. coins .." \z
                           store tournament coins for the ".. targetPlayer:getName() .." account.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." \z
                                 added ".. coins .." store tournament coins to your account.")
	-- Distro log
	Spdlog.info("".. player:getName() .." added ".. coins .." \z
                store tournament coins to ".. targetPlayer:getName() .." account.")
	return true
end

addTournamentCoins:separator(" ")
addTournamentCoins:register()

local removeTournamentCoins = TalkAction("/removeTournamentCoins")

function removeTournamentCoins.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		-- Distro log
		Spdlog.error("[removeTournamentCoins.onSay] - Player name param not found")
		return false
	end

	local split = param:split(",")
	-- Check if have all parameters (god and coinscount)
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters")
		-- Distro log
		Spdlog.error("[removeTournamentCoins.onSay] - Insufficient parameters")
		return false
	end

	-- Check if player is online
	local targetPlayer = Player(split[1])
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(split[1]) .." is not online")
		-- Distro log
		Spdlog.error("[removeTournamentCoins.onSay] - Player ".. string.titleCase(split[1]) .." is not online")
		return false
	end

	-- Trim left
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")

	-- Keep the coinscount in variable "coins"
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
	targetPlayer:removeStoreCoins(coins, COIN_TYPE_TOURNAMENT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfull removed ".. coins .." \z
                           store tournament coins for the ".. targetPlayer:getName() .." account.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." \z
                                 removed ".. coins .." store tournament coins to your account.")
	-- Distro log
	Spdlog.info("".. player:getName() .." removed ".. coins .." store tournament \z
                coins to ".. targetPlayer:getName() .." account.")
	return true
end

removeTournamentCoins:separator(" ")
removeTournamentCoins:register()

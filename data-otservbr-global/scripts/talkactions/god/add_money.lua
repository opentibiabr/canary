local addMoney = TalkAction("/addmoney")

function addMoney.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		-- Distro log
		Spdlog.error("[addMoney.onSay] - Player name param not found")
		return false
	end

	local split = param:split(",")
	local name = split[1]
	local money = nil
	if split[2] then
		money = tonumber(split[2])
	end

	-- Check if player is online
	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Player ".. string.titleCase(name) .." is not online.")
		-- Distro log
		Spdlog.error("[addMoney.onSay] - Player ".. string.titleCase(name) .." is not online")
		return false
	end

	-- Check if the coins is valid
	if money <= 0 or money == nil then
		player:sendCancelMessage("Invalid money count.")
		return false
	end

	targetPlayer:setBankBalance(targetPlayer:getBankBalance() + money)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfull added ".. money .." \z
                           gold coins for the ".. targetPlayer:getName() .." player.")
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "".. player:getName() .." added \z
	                             ".. money .." gold coins to your character.")
	-- Distro log
	Spdlog.info("".. player:getName() .." added ".. money .." gold coins to ".. targetPlayer:getName() .." player")
	return true
end

addMoney:separator(" ")
addMoney:register()

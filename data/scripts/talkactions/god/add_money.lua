-- /addmoney playername, 100000

local addMoney = TalkAction("/addmoney")

function addMoney.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		-- Distro log
		Spdlog.error("[addMoney.onSay] - Player name param not found")
		return true
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
		player:sendCancelMessage("Player " .. string.titleCase(name) .. " is not online.")
		-- Distro log
		Spdlog.error("[addMoney.onSay] - Player " .. string.titleCase(name) .. " is not online")
		return true
	end

	-- Check if the coins is valid
	if money <= 0 or money == nil then
		player:sendCancelMessage("Invalid money count.")
		return true
	end

	targetPlayer:setBankBalance(targetPlayer:getBankBalance() + money)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Successful added %d gold coins for the %s player.", money, targetPlayer:getName()))
	targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s added %d gold coins to your character.", player:getName(), money))
	-- Distro log
	Spdlog.info("" .. player:getName() .. " added " .. money .. " gold coins to " .. targetPlayer:getName() .. " player")
	return true
end

addMoney:separator(" ")
addMoney:groupType("god")
addMoney:register()

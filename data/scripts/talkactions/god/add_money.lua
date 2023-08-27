-- /addmoney playername, 100000

local addMoney = TalkAction("/addmoney")

function addMoney.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		-- Distro log
		logger.error("[addMoney.onSay] - Player name param not found")
		return true
	end

	local split = param:split(",")
	local name = split[1]:trim()

	local normalizedName = Game.getNormalizedPlayerName(name)
	if not normalizedName then
		player:sendCancelMessage("A player with name " .. name .. " does not exist.")
		return false
	end
	name = normalizedName

	local amount = nil
	if split[2] then
		amount = tonumber(split[2])
	end

	-- Check if the coins is valid
	if amount <= 0 or amount == nil then
		player:sendCancelMessage("Invalid amount.")
		return false
	end

	if not Bank.credit(name, amount) then
		player:sendCancelMessage("Failed to add money to " .. name .. ".")
		-- Distro log
		logger.error("[addMoney.onSay] - Failed to add money to player")
		return false
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Successfull added " .. amount .. " gold coins to " .. name .. ".")
	local targetPlayer = Player(name)
	if targetPlayer then
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "" .. player:getName() .. " added " .. amount .. " gold coins to your character.")
	end
	-- Distro log
	logger.info("{} added {} gold coins to {} player", player:getName(), amount, name)
	return true
end

addMoney:separator(" ")
addMoney:groupType("god")
addMoney:register()

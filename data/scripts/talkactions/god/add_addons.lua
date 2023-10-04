-- /addaddons playername

local addons = TalkAction("/addaddons")

function addons.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local target
	if param == "" then
		target = player:getTarget()
		if not target then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gives players the ability to wear all addons. Usage: /addaddons <player name>")
			return true
		end
	else
		target = Player(param)
	end

	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. param .. " is currently not online.")
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Cannot perform action.")
		return true
	end

	target:addAddonToAllOutfits(3)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All addons unlocked for " .. target:getName() .. ".")
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All of your addons have been unlocked!")
	return true
end

addons:separator(" ")
addons:groupType("god")
addons:register()

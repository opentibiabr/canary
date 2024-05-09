local addTitle = TalkAction("/addtitle")

function addTitle.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters. Usage: /addtitle playerName, badgeID")
		return true
	end

	local target = Player(split[1])
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	split[2] = split[2]:trimSpace()
	local id = tonumber(split[2])
	if target:addTitle(id) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format('You added a title with ID "%i" to player "%s".', id, target:getName()))
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s added a title to you.", player:getName()))
	end

	return true
end

addTitle:separator(" ")
addTitle:groupType("god")
addTitle:register()

-----------------------------------------
local setTitle = TalkAction("/settitle")

function setTitle.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters. Usage: /settitle playerName, badgeID")
		return true
	end

	local target = Player(split[1])
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	split[2] = split[2]:trimSpace()
	local id = tonumber(split[2])
	target:setCurrentTitle(id)
	return true
end

setTitle:separator(" ")
setTitle:groupType("god")
setTitle:register()

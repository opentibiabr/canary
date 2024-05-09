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

	split[2] = split[2]:trimSpace() -- Trim left
	local id = tonumber(split[2])
	target:addTitle(id)
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

	split[2] = split[2]:trimSpace() -- Trim left
	local id = tonumber(split[2])
	target:setCurrentTitle(id)
	return true
end

setTitle:separator(" ")
setTitle:groupType("god")
setTitle:register()

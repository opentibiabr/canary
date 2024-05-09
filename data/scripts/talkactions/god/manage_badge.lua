local addBadge = TalkAction("/addbadge")

function addBadge.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters. Usage: /addbadge playerName, badgeID")
		return true
	end

	local target = Player(split[1])
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	split[2] = split[2]:trimSpace() -- Trim left
	local id = tonumber(split[2])
	target:addBadge(id)
	return true
end

addBadge:separator(" ")
addBadge:groupType("god")
addBadge:register()

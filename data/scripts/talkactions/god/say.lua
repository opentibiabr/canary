local talkaction = TalkAction("/say")

function talkaction.onSay(player, words, param)
	local usage = "Usage: /say <player>,<message>"

	if not param or param == "" then
		player:sendCancelMessage(usage)
		return false
	end

	local split = param:split(",")
	if #split < 2 then
		player:sendCancelMessage(usage)
		return false
	end

	local targetName = string.trimSpace(split[1])
	local message = string.trimSpace(split[2])

	local target = Player(targetName)
	if not target then
		player:sendCancelMessage("Player " .. targetName .. " not found.")
		return true
	end

	if isPlayerGhost(target) and getPlayerGhostAccess(target) > getPlayerGhostAccess(player) then
		player:sendCancelMessage("Player " .. targetName .. " not found.")
		return true
	end

	target:say(message, TALKTYPE_SAY)

	return true
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()

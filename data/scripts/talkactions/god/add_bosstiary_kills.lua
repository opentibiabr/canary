local talkaction = TalkAction("/addbosskill")

function talkaction.onSay(player, words, param)
	local usage = "Usage: /addbosskill <kills>,<monster name>,<optional target name>"
	if not HasValidTalkActionParams(player, param, usage) then
		return false
	end

	local split = param:split(",")
	local kills = tonumber(split[1])
	local monsterName = string.capitalize(string.trimSpace(tostring(split[2])))
	local targetName = string.capitalize(string.trimSpace(tostring(split[3])))

	if not kills or kills < 1 then
		player:sendCancelMessage("Invalid kill count.")
		return true
	end

	local target = targetName ~= "" and Player(targetName) or player
	if not target then
		player:sendCancelMessage("Target player not found.")
		return true
	end

	local message = "Added received kills: " .. kills .. ", for boss: " .. monsterName
	if target == player then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, message .. " to yourself.")
	else
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, message .. " to player: " .. targetName)
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received kills: " .. kills .. ", to boss: " .. monsterName)
	end
	target:addBosstiaryKill(monsterName, kills)
	return true
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()

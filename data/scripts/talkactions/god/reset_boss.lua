local talkaction = TalkAction("/resetboss")

function talkaction.onSay(player, words, param)
	local usage = "Usage: /resetboss <player>,<boss name>"
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
	local bossName = string.trimSpace(split[2])

	for i = 3, #split do
		bossName = bossName .. ", " .. string.trimSpace(split[i])
	end

	local target = Player(targetName)
	if not target then
		player:sendCancelMessage("Player " .. targetName .. " not found.")
		return true
	end

	if isPlayerGhost(target) and getPlayerGhostAccess(target) > getPlayerGhostAccess(player) then
		player:sendCancelMessage("Player " .. targetName .. " not found.")
		return true
	end

	local mType = MonsterType(bossName)
	if not mType then
		player:sendCancelMessage("Boss '" .. bossName .. "' not found. Use the exact monster name.")
		return true
	end

	target:setBossCooldown(bossName, 0)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reset boss cooldown [" .. bossName .. "] for player " .. target:getName())
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your cooldown for boss '" .. bossName .. "' has been reset.")

	return true
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()

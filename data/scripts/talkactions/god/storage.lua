local talkaction = TalkAction("/storage")

function talkaction.onSay(player, words, param)
	local usage = "Usage: /storage <player>,<storage key>,<optional value>"
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
	local storageKey = tonumber(split[2])
	local storageValue = split[3] and tonumber(split[3])

	if not storageKey then
		player:sendCancelMessage("Invalid storage key. It must be a number.")
		return true
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

	if not storageValue then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[" .. target:getName() .. " - " .. storageKey .. "] = " .. target:getStorageValue(storageKey))
	else
		target:setStorageValue(storageKey, storageValue)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Set storage [" .. storageKey .. "] = " .. storageValue .. " for player " .. target:getName())
	end

	return true
end

talkaction:separator(" ")
talkaction:groupType("god")
talkaction:register()

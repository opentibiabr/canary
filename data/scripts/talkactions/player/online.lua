local maxPlayersPerMessage = 10
local playersOnline = TalkAction("!online")

local function formatOnlineEntry(player)
	return ("%s [%d|%s]"):format(player:getName(), player:getLevel(), player:vocationAbbrev())
end

function playersOnline.onSay(player, words, param)
	local hasAccess = player:getGroup():getAccess()
	local players = Game.getPlayers()
	local onlineList = {
		Training = {},
		Idle = {},
		Active = {},
	}

	for _, targetPlayer in ipairs(players) do
		if hasAccess or not targetPlayer:isInGhostMode() then
			if onExerciseTraining[targetPlayer:getId()] then
				table.insert(onlineList.Training, targetPlayer)
			elseif targetPlayer:getIdleTime() >= 5 * 60 * 1000 then
				table.insert(onlineList.Idle, targetPlayer)
			else
				table.insert(onlineList.Active, targetPlayer)
			end
		end
	end

	local onlineCount = #onlineList.Training + #onlineList.Idle + #onlineList.Active
	player:sendTextMessage(MESSAGE_ATTENTION, ("%d players online | Training: %d | Idle: %d | Active: %s"):format(onlineCount, #onlineList.Training, #onlineList.Idle, #onlineList.Active))

	for category, list in pairs(onlineList) do
		if #list > 0 then
			local prefix = category .. ": "
			while #list > 0 do
				local msg = {}
				for _ = 1, maxPlayersPerMessage do
					local targetPlayer = list[1]
					if targetPlayer then
						table.insert(msg, formatOnlineEntry(targetPlayer))
						table.remove(list, 1)
					end
				end
				player:sendTextMessage(MESSAGE_ATTENTION, prefix .. table.concat(msg, ", "))
				prefix = ""
			end
		end
	end
	return true
end

playersOnline:groupType("normal")
playersOnline:register()

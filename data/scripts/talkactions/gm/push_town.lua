local pushTown = TalkAction("/t")

function pushTown.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:teleportTo(player:getTown():getTemplePosition())
	else
		local targetPlayer = Player(param)
		if not targetPlayer then
			player:sendCancelMessage("A player with that name is not online.")
			return true
		end
		player:sendTextMessage(MESSAGE_STATUS, "You have teleported " .. targetPlayer:getName() .. " to temple.")
		targetPlayer:teleportTo(targetPlayer:getTown():getTemplePosition())
		targetPlayer:sendTextMessage(MESSAGE_STATUS, "You have been teleported to your temple.")
		targetPlayer:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		local text = "Player " .. targetPlayer:getName() .. " has been teleported to temple by " .. player:getName() .. "."
		logger.info("[pushTown.onSay] - {}", text)
		Webhook.sendMessage("Player Teleported", text, WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
	end
	return true
end

pushTown:separator(" ")
pushTown:groupType("gamemaster")
pushTown:register()

---------------------------------------------

local pushDp = TalkAction("/dp")

function pushDp.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local dpPos = Position(32345, 32224, 7)

	if param == "" then
		player:teleportTo(dpPos)
	else
		local targetPlayer = Player(param)
		if not targetPlayer then
			player:sendCancelMessage("A player with that name is not online.")
			return true
		end
		player:sendTextMessage(MESSAGE_STATUS, "You have teleported " .. targetPlayer:getName() .. " to depot.")
		targetPlayer:teleportTo(dpPos)
		targetPlayer:sendTextMessage(MESSAGE_STATUS, "You have been teleported to depot.")
		targetPlayer:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		logger.info("[pushDp.onSay] - Player {} has been teleported to depot by {}.", targetPlayer:getName(), player:getName())
	end
	return true
end

pushTown:separator(" ")
pushDp:groupType("gamemaster")
pushDp:register()

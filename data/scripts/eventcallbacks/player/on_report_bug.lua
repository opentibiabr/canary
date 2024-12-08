local callback = EventCallback("PlayerOnReportBug")

function callback.playerOnReportBug(player, message, position, category)
	local name = player:getName()
	local filePath = string.format("%s/reports/bugs/%s.txt", CORE_DIRECTORY, name)
	local file = io.open(filePath, "a")

	if not file then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when processing your report, please contact a gamemaster.")
		return true
	end

	file:write("------------------------------\n")
	file:write(string.format("Name: %s", name))

	if category == BUG_CATEGORY_MAP then
		file:write(string.format(" [Map position: %d, %d, %d]", position.x, position.y, position.z))
	end

	local playerPosition = player:getPosition()
	file:write(string.format(" [Player Position: %d, %d, %d]\n", playerPosition.x, playerPosition.y, playerPosition.z))
	file:write(string.format("Comment: %s\n", message))
	file:write("------------------------------\n")
	file:close()

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your report has been sent to %s.", configManager.getString(configKeys.SERVER_NAME)))
	return true
end

callback:register()

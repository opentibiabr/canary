local ec = EventCallback

function ec.onReportBug(player, message, position, category)
	if player:getAccountType() == ACCOUNT_TYPE_NORMAL then
		return false
	end

	local name = player:getName()
	local file = io.open(string.format("%s/reports/bugs/%s/report.txt", CORE_DIRECTORY, name), "a")

	if not file then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"There was an error when processing your report, please contact a gamemaster.")
		return true
	end

	io.output(file)
	io.write("------------------------------\n")
	io.write("Name: " .. name)
	if category == BUG_CATEGORY_MAP then
		io.write(" [Map position: " .. position.x .. ", " .. position.y .. ", " .. position.z .. "]")
	end
	local playerPosition = player:getPosition()
	io.write(" [Player Position: " .. playerPosition.x .. ", " .. playerPosition.y .. ", " .. playerPosition.z .. "]\n")
	io.write("Comment: " .. message .. "\n")
	io.close(file)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		"Your report has been sent to " .. configManager.getString(configKeys.SERVER_NAME) .. ".")
	return true
end

ec:register(--[[0]])

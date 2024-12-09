local function hasPendingReport(name, targetName, reportType)
	local filePath = string.format("%s/reports/players/%s-%s-%d.txt", CORE_DIRECTORY, name, targetName, reportType)
	local file = io.open(filePath, "r")
	if file then
		io.close(file)
		return true
	end
	return false
end

local callback = EventCallback("PlayerOnReportRuleViolation")

function callback.playerOnReportRuleViolation(player, targetName, reportType, reportReason, comment, translation)
	local name = player:getName()

	if hasPendingReport(name, targetName, reportType) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your report is being processed.")
		return
	end

	local filePath = string.format("%s/reports/players/%s-%s-%d.txt", CORE_DIRECTORY, name, targetName, reportType)
	local file = io.open(filePath, "a")
	if not file then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There was an error when processing your report, please contact a gamemaster.")
		return
	end

	file:write("------------------------------\n")
	file:write(string.format("Reported by: %s\n", name))
	file:write(string.format("Target: %s\n", targetName))
	file:write(string.format("Type: %d\n", reportType))
	file:write(string.format("Reason: %s\n", reportReason))
	file:write(string.format("Comment: %s\n", comment))

	if reportType ~= REPORT_TYPE_BOT then
		file:write(string.format("Translation: %s\n", translation))
	end

	file:write("------------------------------\n")
	file:close()

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Thank you for reporting %s. Your report will be processed by %s team as soon as possible.", targetName, configManager.getString(configKeys.SERVER_NAME)))
end

callback:register()

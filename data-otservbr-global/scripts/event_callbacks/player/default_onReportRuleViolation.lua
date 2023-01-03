local function hasPendingReport(name, targetName, reportType)
	local f = io.open(string.format("%s/reports/players/%s-%s-%d.txt", CORE_DIRECTORY, name, targetName, reportType), "r")
	if f then
		io.close(f)
		return true
	end
	return false
end

local ec = EventCallback

function ec.onReportRuleViolation(player, targetName, reportType, reportReason, comment, translation)
	local name = player:getName()
	if hasPendingReport(name, targetName, reportType) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your report is being processed.")
		return
	end

	local file = io.open(string.format("%s/reports/players/%s-%s-%d.txt", CORE_DIRECTORY, name, targetName, reportType), "a")
	if not file then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"There was an error when processing your report, please contact a gamemaster.")
		return
	end

	io.output(file)
	io.write("------------------------------\n")
	io.write("Reported by: " .. name .. "\n")
	io.write("Target: " .. targetName .. "\n")
	io.write("Type: " .. reportType .. "\n")
	io.write("Reason: " .. reportReason .. "\n")
	io.write("Comment: " .. comment .. "\n")
	if reportType ~= REPORT_TYPE_BOT then
		io.write("Translation: " .. translation .. "\n")
	end
	io.write("------------------------------\n")
	io.close(file)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Thank you for reporting %s. Your report \z
	will be processed by %s team as soon as possible.", targetName, configManager.getString(configKeys.SERVER_NAME)))
end

ec:register(--[[0]])

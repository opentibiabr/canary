-- Function to check duplicated variable keys and log the results
local function checkAndLogDuplicateKeys(variableNames)
	for _, variableName in ipairs(variableNames) do
			local duplicates = checkDuplicateStorageKeys(variableName)
			if duplicates then
					local message = "Duplicate keys found: " .. table.concat(duplicates, ", ")
					logger.warn("Checking " .. variableName .. ": " .. message)
			else
					logger.info("Checking " .. variableName .. ": No duplicate keys found.")
			end
	end
end

local startup = GlobalEvent("Startup")

function startup.onStartup()
	-- Call the checkAndLogDuplicateKeys function with the list of variable names
	local variableNames = {"Global", "GlobalStorage", "Storage"}
	checkAndLogDuplicateKeys(variableNames)
end

startup:register()

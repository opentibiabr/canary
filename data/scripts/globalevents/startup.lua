-- Function to check for duplicate keys in a given variable's storage
local function checkDuplicateStorageKeys(varName)
	local keys = _G[varName]
	local seen = {}
	local duplicates = {}

	for k, v in pairs(keys) do
		if seen[v] then
			table.insert(duplicates, v)
		else
			seen[v] = true
		end
	end

	return next(duplicates) and duplicates or false
end

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

local startup = GlobalEvent("Server Initialization")

function startup.onStartup()
	checkAndLogDuplicateKeys({ "Global", "GlobalStorage", "Storage" })
end

startup:register()

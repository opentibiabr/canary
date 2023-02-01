--[[
Reserved player action storage key ranges (const.hpp)
	It is possible to place the storage in a quest door, so the player who has that storage will go through the door

	Reserved player action storage key ranges (const.hpp at the source)
	[10000000 - 20000000]
	[1000 - 1500]
	[2001 - 2011]

	Others reserved player action/storages
	[100] = unmoveable/untrade/unusable items
	[101] = use pick floor
	[102] = well down action
	[103-120] = others keys action
	[103] = key 0010
	[303] = key 0303
	[1000] = level door. Here 1 must be used followed by the level.
	Example: 1010 = level 10,
	1100 = level 100]

	Questline = Storage through the Quest
]]

Storage = {
	Quest = {
		Key = {
			ID1000 = 103
		},
		ExampleQuest = {
			Example = 9000,
			Door = 9001
		}
	},

	NpcExhaust = 30000,
	StoreExaust = 30001,
	DelayLargeSeaShell = 30002,
	Promotion = 30003,
	Imbuement = 30004,
	FamiliarSummon = 30005,
	FamiliarSummonEvent10 = 30006,
	FamiliarSummonEvent60 = 30007
}

GlobalStorage = {
	XpDisplayMode = 65006,
	ExampleQuest = {
		Example = 60000
	}
}

-- Function to check for duplicate keys in a table
-- Receives the name of the table to be checked as argument
function checkDuplicatesStorages(varName)
	-- Retrieve the table to be checked
	local keys = _G[varName]
	-- Create a table to keep track of the keys already seen
	local seen = {}
	-- Iterate over the keys in the table
	for k, v in pairs(keys) do
			-- Check if a key has already been seen
			if seen[v] then
					-- If it has, return true and the duplicate key
					return true, "Duplicate key found: " .. v
			end
			-- If not, add the key to the seen table
			seen[v] = true
	end
	-- If no duplicates were found, return false and a message indicating that
	return false, "No duplicate keys found."
end

-- List of table names to be checked for duplicates
local variableNames = {"Storage", "GlobalStorage"}
-- Loop through the list of table names
for _, variableName in ipairs(variableNames) do
	-- Call the checkDuplicatesStorages function for each table
	local hasDuplicates, message = checkDuplicatesStorages(variableName)
	-- Print the result of the check for each table
	Spdlog.warn(">> Checking storages " .. variableName .. ": " .. message)
end

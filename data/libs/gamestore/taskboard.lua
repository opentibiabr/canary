local taskboard = {}

local function getExpansion()
	local api = rawget(_G, "Taskboard")
	if type(api) ~= "table" or type(api.expansion) ~= "table" then
		return nil
	end
	return api.expansion
end

function taskboard.isWeeklyExpansionUnlocked(player)
	local expansion = getExpansion()
	if not expansion or type(expansion.isUnlocked) ~= "function" then
		return nil
	end

	local ok, unlocked = pcall(expansion.isUnlocked, player)
	if not ok then
		return nil
	end
	return unlocked == true
end

function taskboard.unlockWeeklyExpansion(player)
	local expansion = getExpansion()
	if not expansion or type(expansion.unlock) ~= "function" then
		return false, "Task Board is unavailable."
	end

	local ok, unlocked, reason = pcall(expansion.unlock, player)
	if not ok then
		return false, "Permanent Weekly Task Expansion could not be unlocked."
	end
	return unlocked == true, reason
end

return taskboard

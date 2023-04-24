function Party:onJoin(player)
	for k, functionCallback in pairs(EventCallback) do
		if type(functionCallback) == "function" and k:sub(1, #("onJoin")) == "onJoin" then
			functionCallback(self, player)
		end
	end

	return true
end

function Party:onLeave(player)
	for k, functionCallback in pairs(EventCallback) do
		if type(functionCallback) == "function" and k:sub(1, #("onLeave")) == "onLeave" then
			functionCallback(self, player)
		end
	end

	return true
end

function Party:onDisband()
	for k, functionCallback in pairs(EventCallback) do
		if type(functionCallback) == "function" and k:sub(1, #("onDisband")) == "onDisband" then
			functionCallback(self)
		end
	end

	return true
end

function Party:onShareExperience(exp)
	for k, functionCallback in pairs(EventCallback) do
		if type(functionCallback) == "function" and k:sub(1, #("onShareExperience")) == "onShareExperience" then
			functionCallback(self, exp)
		end
	end

	local sharedExperienceMultiplier = 1.20 --20%
	local vocationsIds = {}

	local vocationId = self:getLeader():getVocation():getBase():getId()
	if vocationId ~= VOCATION_NONE then
		table.insert(vocationsIds, vocationId)
	end

	for _, member in ipairs(self:getMembers()) do
		vocationId = member:getVocation():getBase():getId()
		if not table.contains(vocationsIds, vocationId) and vocationId ~= VOCATION_NONE then
			table.insert(vocationsIds, vocationId)
		end
	end

	local size = #vocationsIds
	if size > 1 then
		sharedExperienceMultiplier = 1.0 + ((size * (5 * (size - 1) + 10)) / 100)
	end

	return (exp * sharedExperienceMultiplier) / (#self:getMembers() + 1)
end

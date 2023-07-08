function Party:onJoin(player)
	addEvent(function() self:refreshHazard() end, 100)
	return true
end

function Party:onLeave(player)
	addEvent(function() self:refreshHazard() end, 100)
	addEvent(function() player:updateHazard() end, 100)
	return true
end

function Party:onDisband()
	local members = self:getMembers()
	table.insert(members, self:getLeader())
	for _, member in ipairs(members) do
		addEvent(function() member:updateHazard() end, 100)
	end
	return true
end

function Party:refreshHazard()
	local members = self:getMembers()
	table.insert(members, self:getLeader())
	local hazard = nil
	local level = -1

	for _, member in ipairs(members) do
		local memberHazard = member:getPosition():getHazardArea()
		if memberHazard then
			if not hazard then
				hazard = memberHazard
			elseif hazard.name ~= memberHazard.name then
				-- Party members are in different hazard areas so we can't calculate the level
				level = 0
				break
			end
		end

		if hazard then
			local memberLevel = hazard:getPlayerCurrentLevel(member)
			if memberLevel < level or level == -1 then
				level = memberLevel
			end
		end
	end
	for _, member in ipairs(members) do
		Spdlog.info("Party:refreshHazard: " .. member:getName() .. " level: " .. level)
		member:setHazardSystemPoints(level)
	end
end

function Party:onShareExperience(exp)
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

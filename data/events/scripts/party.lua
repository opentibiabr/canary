function Party:onJoin(player)
	local playerId = player:getId()
	addEvent(function()
		player = Player(playerId)
		if not player then
			return
		end
		local party = player:getParty()
		if not party then
			return
		end
		party:refreshHazard()
	end, 100)
	return true
end

function Party:onLeave(player)
	local playerId = player:getId()
	local members = self:getMembers()
	table.insert(members, self:getLeader())
	local memberIds = {}
	for _, member in ipairs(members) do
		if member:getId() ~= playerId then
			table.insert(memberIds, member:getId())
		end
	end

	addEvent(function()
		player = Player(playerId)
		if player then
			player:updateHazard()
		end

		for _, memberId in ipairs(memberIds) do
			local member = Player(memberId)
			if member then
				local party = member:getParty()
				if party then
					party:refreshHazard()
					return -- Only one player needs to refresh the hazard for the party
				end
			end
		end
	end, 100)
	return true
end

function Party:onDisband()
	local members = self:getMembers()
	table.insert(members, self:getLeader())
	local memberIds = {}
	for _, member in ipairs(members) do
		if member:getId() ~= playerId then
			table.insert(memberIds, member:getId())
		end
	end
	addEvent(function()
		for _, memberId in ipairs(memberIds) do
			local member = Player(memberId)
			if member then
				member:updateHazard()
			end
		end
	end, 100)
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

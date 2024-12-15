function Party:onJoin(player)
	local playerUid = player:getGuid()
	addEvent(function(playerFuncUid)
		local playerEvent = Player(playerFuncUid)
		if not playerEvent then
			return
		end
		local party = playerEvent:getParty()
		if not party then
			return
		end
		party:refreshHazard()
	end, 100, playerUid)
	return true
end

function Party:onLeave(player)
	local playerUid = player:getGuid()
	local members = self:getMembers()
	table.insert(members, self:getLeader())
	local memberUids = {}
	for _, member in ipairs(members) do
		if member:getGuid() ~= playerUid then
			table.insert(memberUids, member:getGuid())
		end
	end

	addEvent(function(playerFuncUid, memberUidsTableEvent)
		local playerEvent = Player(playerFuncUid)
		if playerEvent then
			playerEvent:updateHazard()
		end

		for _, memberUid in ipairs(memberUidsTableEvent) do
			local member = Player(memberUid)
			if member then
				local party = member:getParty()
				if party then
					party:refreshHazard()
					return -- Only one player needs to refresh the hazard for the party
				end
			end
		end
	end, 100, playerUid, memberUids)
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

function Party:onShareExperience(exp)
	local uniqueVocationsCount = self:getUniqueVocationsCount()
	local partySize = self:getMemberCount() + 1

	-- Formula to calculate the % based on the vocations amount
	local sharedExperienceMultiplier = ((0.1 * (uniqueVocationsCount ^ 2)) - (0.2 * uniqueVocationsCount) + 1.3)
	-- Since the formula its non linear, we need to subtract 0.1 if all vocations are present,
	-- because on all vocations the multiplier is 2.1 and it should be 2.0
	sharedExperienceMultiplier = partySize < 4 and sharedExperienceMultiplier or sharedExperienceMultiplier - 0.1

	return math.ceil((exp * sharedExperienceMultiplier) / partySize)
end

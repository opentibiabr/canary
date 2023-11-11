function Party.broadcastPartyLoot(self, text)
	self:getLeader():sendTextMessage(MESSAGE_LOOT, text)
	local membersList = self:getMembers()
	for i = 1, #membersList do
		local player = membersList[i]
		if player then
			player:sendTextMessage(MESSAGE_LOOT, text)
		end
	end
end

function Party:refreshHazard()
	local members = self:getMembers()
	table.insert(members, self:getLeader())
	local hazard = nil
	local level = -1

	for _, member in ipairs(members) do
		local zones = member:getZones()
		if zones then
			for _, zone in ipairs(zones) do
				local memberHazard = Hazard.getByName(zone:getName())
				if memberHazard then
					if not hazard then
						hazard = memberHazard
					elseif hazard.name ~= memberHazard.name then
						-- Party members are in different hazard areas so we can't calculate the level
						level = 0
						break
					end
				end
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

function Party.hasVocation(self, vocationId)
	if self:getLeader():getVocation():getBaseId() == vocationId then
		return true
	end
	local membersList = self:getMembers()
	for i = 1, #membersList do
		local player = membersList[i]
		if player and player:getVocation():getBaseId() == vocationId then
			return true
		end
	end
	return false
end

function Party.hasKnight(self)
	return self:hasVocation(VOCATION.BASE_ID.KNIGHT)
end

function Party.hasPaladin(self)
	return self:hasVocation(VOCATION.BASE_ID.PALADIN)
end

function Party.hasSorcerer(self)
	return self:hasVocation(VOCATION.BASE_ID.SORCERER)
end

function Party.hasDruid(self)
	return self:hasVocation(VOCATION.BASE_ID.DRUID)
end

function Participants(player, requireSharedExperience)
	local party = player:getParty()
	if not party then
		return { player }
	end
	if requiredSharedExperience and not party:isSharedExperienceActive() then
		return { player }
	end
	local members = party:getMembers()
	table.insert(members, party:getLeader())
	return members
end

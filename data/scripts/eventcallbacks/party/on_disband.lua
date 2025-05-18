local callback = EventCallback("PartyOnDisbandEventBaseEvent")

function callback.partyOnDisband(party)
	local members = party:getMembers()
	table.insert(members, party:getLeader())
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

callback:register()

local callback = EventCallback()

function callback.monsterPostDropLoot(monster, corpse)
	local player = Player(corpse:getCorpseOwner())
	if not player then
		return
	end
	if player:getStamina() <= 840 then
		return
	end
	local mType = monster:getType()
	if not mType then
		return
	end

	local participants = { player }
	local party = player:getParty()
	if party and party:isSharedExperienceEnabled() then
		participants = party:getMembers()
		table.insert(participants, party:getLeader())
	end

	for _, participant in ipairs(participants) do
		if participant then
			participant:updateKillTracker(monster, corpse)
		end
	end
end

callback:register()

local callback = EventCallback("MonsterOnDropLootPrey")

function callback.monsterOnDropLoot(monster, corpse)
	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end
	local mType = monster:getType()
	if not mType then
		return
	end

	local factor = 1.0
	local msgSuffix = ""
	local participants = { player }
	if configManager.getBoolean(configKeys.PARTY_SHARE_LOOT_BOOSTS) then
		local party = player:getParty()
		if party and party:isSharedExperienceEnabled() then
			participants = party:getMembers()
			table.insert(participants, party:getLeader())
		end
	end

	local preyChance = 0
	local preyActivators = {}
	for _, participant in ipairs(participants) do
		local participantChance = participant:getPreyLootPercentage(mType:raceId())
		table.insert(preyActivators, participant:getName())
		preyChance = preyChance + participantChance
	end
	if #preyActivators > 0 then
		local numActivators = #preyActivators
		preyChance = preyChance / numActivators ^ configManager.getFloat(configKeys.PARTY_SHARE_LOOT_BOOSTS_DIMINISHING_FACTOR)
	end
	if math.random(1, 100) > preyChance then
		return
	end

	if configManager.getBoolean(configKeys.PARTY_SHARE_LOOT_BOOSTS) then
		msgSuffix = msgSuffix .. " (active prey bonus for " .. table.concat(preyActivators, ", ") .. ")"
	else
		msgSuffix = msgSuffix .. " (active prey bonus)"
	end

	corpse:addLoot(mType:generateLootRoll({ factor = factor, gut = false }, {}, player))
	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()

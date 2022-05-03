function Monster:onDropLoot(corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end

	-- Register reward function from reward boss lib
	self:registerRewardBoss(corpse)

	local player = Player(corpse:getCorpseOwner())
	local mType = self:getType()
	if not player or player:getStamina() > 840 then
		local monsterLoot = mType:getLoot()
		local preyChanceBoost = 100
		local charmBonus = false
		if player and mType and mType:raceId() > 0 then
			preyChanceBoost = player:getPreyLootPercentage(mType:raceId())
			local charm = player:getCharmMonsterType(CHARM_GUT)
			if charm and charm:raceId() == mType:raceId() then
				charmBonus = true
			end
		end

		for i = 1, #monsterLoot do
			local item = corpse:createLootItem(monsterLoot[i], charmBonus, preyChanceBoost)
			if self:getName():lower() == Game.getBoostedCreature():lower() then
				local itemBoosted = corpse:createLootItem(monsterLoot[i], charmBonus, preyChanceBoost)
				if not itemBoosted then
					Spdlog.warn(string.format("[Monster:onDropLoot] - Could not add loot item to boosted monster: %s, from corpse id: %d.", self:getName(), corpse:getId()))
				end
			end
			if not item then
				Spdlog.warn(string.format("[Monster:onDropLoot] - Could not add loot item to monster: %s, from corpse id: %d.", self:getName(), corpse:getId()))
			end
		end

		if player then
			local text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())
			if preyChanceBoost ~= 100 then
				text = text .. " (active prey bonus)"
			end
			if charmBonus then
				text = text .. " (active charm bonus)"
			end
			local party = player:getParty()
			if party then
				party:broadcastPartyLoot(text)
			else
				player:sendTextMessage(MESSAGE_LOOT, text)
			end
		end
	else
		local text = ("Loot of %s: nothing (due to low stamina)"):format(mType:getNameDescription())
		local party = player:getParty()
		if party then
			party:broadcastPartyLoot(text)
		else
			player:sendTextMessage(MESSAGE_LOOT, text)
		end
	end
end

function Monster:onSpawn(position)
	-- Register reward function from reward boss lib
	self:setRewardBoss()
end

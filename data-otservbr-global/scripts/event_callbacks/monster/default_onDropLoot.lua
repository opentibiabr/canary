local ec = EventCallback

function ec.onDropLoot(monster, corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end

	local mType = monster:getType()
	if mType:isRewardBoss() then
		corpse:registerReward()
		return
	end

	local player = Player(corpse:getCorpseOwner())
	if not player or player:getStamina() > 840 then
		local monsterLoot = mType:getLoot()
		local charmBonus = false
		if player and mType and mType:raceId() > 0 then
			local charm = player:getCharmMonsterType(CHARM_GUT)
			if charm and charm:raceId() == mType:raceId() then
				charmBonus = true
			end
		end

		for i = 1, #monsterLoot do
			local item = corpse:createLootItem(monsterLoot[i], charmBonus)
			if monster:getName():lower() == Game.getBoostedCreature():lower() then
				local itemBoosted = corpse:createLootItem(monsterLoot[i], charmBonus)
				if not itemBoosted then
					Spdlog.warn(string.format("[1][Monster:onDropLoot] - Could not add loot item to boosted monster: %s, from corpse id: %d.", monster:getName(), corpse:getId()))
				end
			end
			if not item then
				Spdlog.warn(string.format("[2][Monster:onDropLoot] - Could not add loot item to monster: %s, from corpse id: %d.", monster:getName(), corpse:getId()))
			end
		end

		if player then
			-- Runs the loot again if the player gets a chance to loot in the prey
			local preyLootPercent = player:getPreyLootPercentage(mType:raceId())
			if preyLootPercent > 0 then
				local probability = math.random(0, 100)
				if probability < preyLootPercent then
					for i, loot in pairs(monsterLoot) do
						local item = corpse:createLootItem(monsterLoot[i], charmBonus)
						if not item then
							Spdlog.warn(string.format("[3][Monster:onDropLoot] - Could not add loot item to monster: %s, from corpse id: %d.", monster:getName(), corpse:getId()))
						end
					end
				end
			end

			local text = {}
			if monster:getName():lower() == (Game.getBoostedCreature()):lower() then
				text = ("Loot of %s: %s (boosted loot)"):format(mType:getNameDescription(), corpse:getContentDescription())
			else
				text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())
			end
			if preyLootPercent > 0 then
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
			player:updateKillTracker(monster, corpse)
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

ec:register(--[[0]])

local function calculateBonus(bonus)
	local bonusCount = math.floor(bonus / 100)
	local remainder = bonus % 100
	if remainder > 0 then
		local probability = math.random(0, 100)
		bonusCount = bonusCount + (probability < remainder and 1 or 0)
	end

	return bonusCount
end

local function checkItemType(itemId)
	local itemType = ItemType(itemId):getType()
	-- Based on enum ItemTypes_t
	if (itemType > 0 and itemType < 4) or itemType == 7 or itemType == 8 or
		itemType == 11 or itemType == 13 or (itemType > 15 and itemType < 22) then
		return true
	end
	return false
end

function Monster:onDropLoot(corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end

	local mType = self:getType()
	if mType:isRewardBoss() then
		corpse:registerReward()
		return
	end

	local player = Player(corpse:getCorpseOwner())
	if not player or player:getStamina() > 840 then
		local monsterLoot = mType:getLoot()
		local charmBonus = false
		local hazardMsg = false
		local wealthDuplexMsg = false
		if player and mType and mType:raceId() > 0 then
			local charm = player:getCharmMonsterType(CHARM_GUT)
			if charm and charm:raceId() == mType:raceId() then
				charmBonus = true
			end
		end

		local participants = {}
		local modifier = 1
		local vipBoost = 0

		if player then
			participants = { player }
			if configManager.getBoolean(PARTY_SHARE_LOOT_BOOSTS) then
				local party = player:getParty()
				if party and party:isSharedExperienceEnabled() then
					participants = party:getMembers()
					table.insert(participants, party:getLeader())
				end
			end
		end

		local wealthDuplex = Concoction.find(Concoction.Ids.WealthDuplex)
		if wealthDuplex then
			for i = 1, #participants do
				local participant = participants[i]
				if participant and wealthDuplex:active(player) then
					modifier = modifier * wealthDuplex.config.multiplier
					wealthDuplexMsg = true
					break
				end
			end
		else
			Spdlog.warn("[Monster:onDropLoot] - Could not find WealthDuplex concoction.")
		end

		for i = 1, #participants do
			local participant = participants[i]
			if participant:isVip() then
				local boost = configManager.getNumber(configKeys.VIP_BONUS_LOOT)
				boost = ((boost > 100 and 100) or boost) / 100
				vipBoost = vipBoost + boost
			end
		end
		vipBoost = vipBoost / ((#participants) ^ 0.5)
		modifier = modifier * (1 + vipBoost)

		for i = 1, #monsterLoot do
			corpse:createLootItem(monsterLoot[i], charmBonus, modifier)
			if self:getName():lower() == Game.getBoostedCreature():lower() then
				 corpse:createLootItem(monsterLoot[i], charmBonus, modifier)
			end
			if self:hazard() and player then
				local chanceTo = math.random(1, 100)
				if chanceTo <= (2 * player:getHazardSystemPoints() * configManager.getNumber(configKeys.HAZARDSYSTEM_LOOT_BONUS_MULTIPLIER)) then
					if corpse:createLootItem(monsterLoot[i], charmBonus, modifier) then
						hazardMsg = true
					end
				end
			end
		end

		if #participants > 0 and player then
			local preyLootPercent = player:getPreyLootPercentage(mType:raceId())
			for i = 1, #participants do
				local participant = participants[i]
				local memberBoost = participant:getPreyLootPercentage(mType:raceId())
				if memberBoost > preyLootPercent then
					preyLootPercent = memberBoost
				end
			end
			-- Runs the loot again if the player gets a chance to loot in the prey
			if preyLootPercent > 0 then
				local probability = math.random(0, 100)
				if probability < preyLootPercent then
					for _, loot in pairs(monsterLoot) do
						 corpse:createLootItem(loot, charmBonus, modifier)
					end
				end
			end

			local boostedMessage
			local isBoostedBoss = self:getName():lower() == (Game.getBoostedBoss()):lower()
			local bossRaceIds = { player:getSlotBossId(1), player:getSlotBossId(2) }
			local isBoss = table.contains(bossRaceIds, mType:bossRaceId()) or isBoostedBoss
			if isBoss and mType:bossRaceId() ~= 0 then
				local bonus
				if mType:bossRaceId() == player:getSlotBossId(1) then
					bonus = player:getBossBonus(1)
				elseif mType:bossRaceId() == player:getSlotBossId(2) then
					bonus = player:getBossBonus(2)
				else
					bonus = configManager.getNumber(configKeys.BOOSTED_BOSS_LOOT_BONUS)
				end

				local items = corpse:getItems(true)
				for i = 1, #items do
					local itemId = items[i]:getId()
					local isValidItem = checkItemType(itemId)
					if isValidItem then
						local realBonus = calculateBonus(bonus)
						for _ = 1, realBonus do
							corpse:addItem(itemId)
							boostedMessage = true
						end
					end
				end
			end

			local contentDescription = corpse:getContentDescription(player:getClient().version < 1200)

			local text = {}
			if self:getName():lower() == (Game.getBoostedCreature()):lower() then
				text = ("Loot of %s: %s (boosted loot)"):format(mType:getNameDescription(), contentDescription)
			elseif boostedMessage then
				text = ("Loot of %s: %s (Boss bonus)"):format(mType:getNameDescription(), contentDescription)
			else
				text = ("Loot of %s: %s"):format(mType:getNameDescription(), contentDescription)
			end
			if preyLootPercent > 0 then
				text = text .. " (active prey bonus)"
			end
			if (vipBoost > 0) then
				text = text .. " (vip loot bonus " .. (vipBoost * 100) .. "%)"
			end
			if charmBonus then
				text = text .. " (active charm bonus)"
			end
			if hazardMsg then
				text = text .. " (Hazard system)"
			end
			if wealthDuplexMsg then
				text = text .. " (active wealth duplex)"
			end
			local party = player:getParty()
			if party then
				party:broadcastPartyLoot(text)
			else
				player:sendTextMessage(MESSAGE_LOOT, text)
			end
			player:updateKillTracker(self, corpse)
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

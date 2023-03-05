local function calculateBonus(bonus)
	local bonusCount = math.floor(bonus/100)
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
		local hazardMsg = false
		local charmBonus = false
		if player and mType and mType:raceId() > 0 then
			local charm = player:getCharmMonsterType(CHARM_GUT)
			if charm and charm:raceId() == mType:raceId() then
				charmBonus = true
			end
		end

		for i = 1, #monsterLoot do
			local item = corpse:createLootItem(monsterLoot[i], charmBonus)
			if self:getName():lower() == Game.getBoostedCreature():lower() then
				local itemBoosted = corpse:createLootItem(monsterLoot[i], charmBonus)
				if not itemBoosted then
					Spdlog.warn(string.format("[1][Monster:onDropLoot] - Could not add loot item to boosted monster: %s, from corpse id: %d.", self:getName(), corpse:getId()))
				end
			end
			if (self:isMonsterOnHazardSystem() and player ~= nil) then
				local chanceTo = math.random(1, 100)
				if (chanceTo <= (2 * player:getHazardSystemPoints() * configManager.getNumber(configKeys.HAZARDSYSTEM_LOOT_BONUS_MULTIPLIER))) then
					local podItem = corpse:createLootItem(monsterLoot[i], charmBonus, preyChanceBoost)
					if not podItem then
						Spdlog.warn(string.format("[Monster:onDropLoot] - Could not add loot item to hazard monster: %s, from corpse id: %d.", self:getName(), corpse:getId()))
					else
						hazardMsg = true
					end
				end
			end
			if not item then
				Spdlog.warn(string.format("[2][Monster:onDropLoot] - Could not add loot item to monster: %s, from corpse id: %d.", self:getName(), corpse:getId()))
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
							Spdlog.warn(string.format("[3][Monster:onDropLoot] - Could not add loot item to monster: %s, from corpse id: %d.", self:getName(), corpse:getId()))
						end
					end
				end
			end

			local boostedMessage
			local isBoostedBoss = self:getName():lower() == (Game.getBoostedBoss()):lower()
			local bossRaceIds = {player:getSlotBossId(1), player:getSlotBossId(2)}
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

			local text = {}
			if self:getName():lower() == (Game.getBoostedCreature()):lower() then
				text = ("Loot of %s: %s (boosted loot)"):format(mType:getNameDescription(), corpse:getContentDescription())
			elseif boostedMessage then
				text = ("Loot of %s: %s (Boss bonus)"):format(mType:getNameDescription(), corpse:getContentDescription())
			else
				text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())
			end
			if preyLootPercent > 0 then
				text = text .. " (active prey bonus)"
			end
			if charmBonus then
				text = text .. " (active charm bonus)"
			end
			if hazardMsg then
				text = text .. " (Hazard system)"
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

function Monster:onSpawn(position)
	if self:getType():isRewardBoss() then
		self:setReward(true)
	end

	-- We won't run anything from here on down if we're opening the global pack
	if IsRunningGlobalDatapack() then
		if self:getName():lower() == "cobra scout" or
			self:getName():lower() == "cobra vizier" or
			self:getName():lower() == "cobra assassin" then
			if getGlobalStorageValue(GlobalStorage.CobraBastionFlask) >= os.time() then
				self:setHealth(self:getMaxHealth() * 0.75)
			end
		end
	end

	if not self:getType():canSpawn(position) then
		self:remove()
	else
		local spec = Game.getSpectators(position, false, false)
		for _, pid in pairs(spec) do
			local monster = Monster(pid)
			if monster and not monster:getType():canSpawn(position) then
				monster:remove()
			end
		end

		if IsRunningGlobalDatapack() then
			if self:getName():lower() == 'iron servant replica' then
				local chance = math.random(100)
				if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1
				and Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 then
					if chance > 30 then
						local chance2 = math.random(2)
						if chance2 == 1 then
							Game.createMonster('diamond servant replica', self:getPosition(), false, true)
						elseif chance2 == 2 then
							Game.createMonster('golden servant replica', self:getPosition(), false, true)
						end
						self:remove()
					end
					return true
				end
				if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1 then
					if chance > 30 then
						Game.createMonster('diamond servant replica', self:getPosition(), false, true)
						self:remove()
					end
				end
				if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 then
					if chance > 30 then
						Game.createMonster('golden servant replica', self:getPosition(), false, true)
						self:remove()
					end
				end
				return true
			end
		end
	end
end

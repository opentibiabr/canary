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

			local boostedMessage
			local isBoostedBoss = monster:getName():lower() == (Game.getBoostedBoss()):lower()
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
			if monster:getName():lower() == (Game.getBoostedCreature()):lower() then
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

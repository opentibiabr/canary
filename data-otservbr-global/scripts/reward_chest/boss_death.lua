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

local bossDeath = CreatureEvent("BossDeath")

function bossDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	-- Deny summons and players
	if not creature or creature:isPlayer() or creature:getMaster() then
		return true
	end

	-- Boss function
	local monsterType = creature:getType()
	-- Make sure it is a boss
	if monsterType and monsterType:isRewardBoss() then
		local bossId = creature:getId()
		local rewardId = corpse:getAttribute(ITEM_ATTRIBUTE_DATE)

		ResetAndSetTargetList(creature)

		-- Avoid dividing by zero
		local totalDamageOut, totalDamageIn, totalHealing = 0.1, 0.1, 0.1

		local scores = {}
		local info = GlobalBosses[bossId]
		local damageMap = creature:getDamageMap()

		for guid, stats in pairs(info) do
			local player = Player(stats.playerId)
			local part = damageMap[stats.playerId]
			local damageOut, damageIn, healing = (stats.damageOut or 0) + (part and part.total or 0), stats.damageIn or 0, stats.healing or 0

			totalDamageOut = totalDamageOut + damageOut
			totalDamageIn = totalDamageIn + damageIn
			totalHealing = totalHealing + healing

			table.insert(scores, {
				player = player,
				guid = guid,
				damageOut = damageOut,
				damageIn = damageIn,
				healing = healing,
			})
		end

		local participants = 0
		for _, con in ipairs(scores) do
			local score = (con.damageOut / totalDamageOut) + (con.damageIn / totalDamageIn) + (con.healing / totalHealing)
			-- Normalize to 0-1
			con.score = score / 3
			if score ~= 0 then
				participants = participants + 1
			end
		end
		table.sort(scores, function(a, b) return a.score > b.score end)

		local expectedScore = 1 / participants

		for _, con in ipairs(scores) do
			-- Ignoring stamina for now because I heard you get receive rewards even when it's depleted
			if con.score ~= 0 then
				local reward, stamina, player
				if con.player then
					player = con.player;
				else
					player = Game.getOfflinePlayer(con.guid)
				end
				reward = player:getReward(rewardId, true)
				stamina = player:getStamina()

				local playerLoot
				local lootFactor = 1
				-- Tone down the loot a notch if there are many participants
				lootFactor = lootFactor / participants ^ (1 / 3)
				-- Increase the loot multiplicatively by how many times the player surpassed the expected score
				lootFactor = lootFactor * (1 + lootFactor) ^ (con.score / expectedScore)
				playerLoot = monsterType:getBossReward(lootFactor, _ == 1)

				for _, p in ipairs(playerLoot) do
					reward:addItem(p[1], p[2])
				end

				-- Bosstiary Loot Bonus
				local bonus, boostedMessage
				local isBoostedBoss = creature:getName():lower() == (Game.getBoostedBoss()):lower()
				local bossRaceIds = {player:getSlotBossId(1), player:getSlotBossId(2)}
				local isBoss = table.contains(bossRaceIds, monsterType:bossRaceId()) or isBoostedBoss
				if isBoss and monsterType:bossRaceId() ~= 0 then
					if monsterType:bossRaceId() == player:getSlotBossId(1) then
						bonus = player:getBossBonus(1)
					elseif monsterType:bossRaceId() == player:getSlotBossId(2) then
						bonus = player:getBossBonus(2)
					else
						bonus = configManager.getNumber(configKeys.BOOSTED_BOSS_LOOT_BONUS)
					end

					for _, p in ipairs(playerLoot) do
						local isValidItem = checkItemType(p[1])
						if isValidItem then
							local realBonus = calculateBonus(bonus)
							for _ = 1, realBonus do
								reward:addItem(p[1], p[2])
								boostedMessage = true
							end
						end
					end
				end
				if con.player then
					local lootMessage = ("The following items dropped by %s are available in your reward chest: %s"):format(creature:getName(), reward:getContentDescription())
					if boostedMessage then
						lootMessage = lootMessage .. " (Boss bonus)"
					end
					if stamina > 840 then
						reward:getContentDescription(lootMessage)
					end
					player:sendTextMessage(MESSAGE_LOOT, lootMessage)
				else
					player:save()
				end
			end
		end
		GlobalBosses[bossId] = nil
	end
	return true
end

bossDeath:register()

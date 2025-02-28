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
		if not corpse or not corpse.isContainer or not corpse:isContainer() then
			if corpse.getId then
				logger.debug("[bossDeath.onDeath] Boss {} has a corpse (id: {}, name: {}), but it is not a container.", creature:getName(), corpse:getId(), corpse:getName())
			else
				logger.debug("[bossDeath.onDeath] Boss {} does not have a corpse or corpse not found at position {}", creature:getName(), creature:getPosition())
			end
			corpse = Game.createItem(ITEM_BAG, 1)
		end
		corpse:registerReward()
		local bossId = creature:getId()
		local rewardId = corpse:getAttribute(ITEM_ATTRIBUTE_DATE)

		ResetAndSetTargetList(creature)

		-- Avoid dividing by zero
		local totalDamageOut, totalDamageIn, totalHealing = 0.1, 0.1, 0.1

		local scores = {}
		local info = _G.GlobalBosses[bossId]
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
		table.sort(scores, function(a, b)
			return a.score > b.score
		end)

		local expectedScore = 1 / participants

		for _, con in ipairs(scores) do
			-- Ignoring stamina for now because I heard you get receive rewards even when it's depleted
			if con.score ~= 0 then
				local reward, stamina, player
				if con.player then
					player = con.player
				else
					player = Game.getOfflinePlayer(con.guid)
				end
				reward = player:getReward(rewardId, true)
				stamina = player:getStamina()

				local lootFactor = 1
				-- Tone down the loot a notch if there are many participants
				lootFactor = lootFactor / participants ^ (1 / 3)
				-- Increase the loot multiplicatively by how many times the player surpassed the expected score
				lootFactor = lootFactor * (1 + lootFactor) ^ (con.score / expectedScore)
				-- Bosstiary Loot Bonus
				local rolls = 1
				local isBoostedBoss = creature:getName():lower() == (Game.getBoostedBoss()):lower()
				local bossRaceIds = { player:getSlotBossId(1), player:getSlotBossId(2) }
				local isBoss = table.contains(bossRaceIds, monsterType:raceId()) or isBoostedBoss
				if isBoss and monsterType:raceId() ~= 0 then
					if monsterType:raceId() == player:getSlotBossId(1) then
						rolls = rolls + player:getBossBonus(1) / 100.0
					elseif monsterType:raceId() == player:getSlotBossId(2) then
						rolls = rolls + player:getBossBonus(2) / 100.0
					else
						rolls = rolls + configManager.getNumber(configKeys.BOOSTED_BOSS_LOOT_BONUS) / 100
					end
				end
				-- decide if we get an extra roll
				if math.random(0, 100) < (rolls % 1) * 100 then
					rolls = math.ceil(rolls)
				else
					rolls = math.floor(rolls)
				end

				local playerLoot = creature:generateGemAtelierLoot()
				playerLoot = monsterType:getBossReward(lootFactor, _ == 1, false, playerLoot, player)
				for _ = 2, rolls do
					playerLoot = monsterType:getBossReward(lootFactor, false, true, playerLoot, player)
				end

				-- Add droped items to reward container
				reward:addRewardBossItems(playerLoot)

				if con.player then
					local collorMessage = player:getClient().version > 1200
					local lootMessage = ("The following items dropped by %s are available in your reward chest: %s"):format(creature:getName(), reward:getContentDescription(collorMessage))
					if rolls > 1 then
						lootMessage = lootMessage .. " (boss bonus)"
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
		_G.GlobalBosses[bossId] = nil
	end
	return true
end

bossDeath:register()

local bossParticipation = CreatureEvent("BossParticipation")

function bossParticipation.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not next(_G.GlobalBosses) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if not creature or not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local stats = creature:inBossFight()
	if not stats then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local creatureId, attackerId = creature:getId(), attacker:getId()
	-- Update player id
	stats.playerId = creatureId

	-- Account for healing of others active in the boss fight
	if primaryType == COMBAT_HEALING and attacker:isPlayer() and attackerId ~= creatureId then
		local healerStats = GetPlayerStats(stats.bossId, attacker:getGuid(), true)
		healerStats.active = true
		-- Update player id
		healerStats.playerId = attackerId
		healerStats.healing = healerStats.healing + primaryDamage
	elseif stats.bossId == attackerId then
		-- Account for damage taken from the boss
		stats.damageIn = stats.damageIn + primaryDamage
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

bossParticipation:register()

local loginBossPlayer = CreatureEvent("LoginBossPlayer")

function loginBossPlayer.onLogin(player)
	player:registerEvent("BossDeath")
	return true
end

loginBossPlayer:register()

local bossThink = CreatureEvent("BossThink")

function bossThink.onThink(creature, interval)
	if not creature then
		return true
	end

	ResetAndSetTargetList(creature)
end

bossThink:register()

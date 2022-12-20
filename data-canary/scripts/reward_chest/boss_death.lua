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
		local timestamp = os.time()

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
			local reward, stamina
			if con.player then
				reward = con.player:getReward(timestamp, true)
				stamina = con.player:getStamina()
			else
				stamina = con.stamina or 0
			end

			local playerLoot
			if con.score ~= 0 then
				local lootFactor = 1
				-- Tone down the loot a notch if there are many participants
				lootFactor = lootFactor / participants ^ (1 / 3)
				-- Increase the loot multiplicatively by how many times the player surpassed the expected score
				lootFactor = lootFactor * (1 + lootFactor) ^ (con.score / expectedScore)
				playerLoot = monsterType:getBossReward(lootFactor, _ == 1)

				if con.player then
					for _, p in ipairs(playerLoot) do
						reward:addItem(p[1], p[2])
					end
				end
			end

			if con.player and con.score ~= 0 then
				local lootMessage = ("The following items dropped by %s are available in your reward chest: %s"):format(creature:getName(), reward:getContentDescription())

				if stamina > 840 then
					reward:getContentDescription(lootMessage)
				end
				con.player:sendTextMessage(MESSAGE_LOOT, lootMessage)
			elseif con.score ~= 0 then
				InsertRewardItems(con.guid, timestamp, playerLoot)
			end
		end

		GlobalBosses[bossId] = nil
	end
	return true
end

bossDeath:register()

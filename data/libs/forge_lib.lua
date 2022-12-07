if not ForgeMonster then
	ForgeMonster = {
		timeLeftToChangeMonsters = {},
		names = {
			[FORGE_NORMAL_MONSTER] = 'normal',
			[FORGE_INFLUENCED_MONSTER] = 'influenced',
			[FORGE_FIENDISH_MONSTER] = 'fiendish'
		},
		chanceToAppear = {
			fiendish = 80,
			influenced = 20
		},
		maxFiendish = 3,
		eventName = 'ForgeMonster'
	}
end

function getFiendishMinutesLeft(leftTime)
	local secLeft = leftTime - os.time()
	local desc = "This monster will stay fiendish for less than"

	if math.floor(secLeft / 60) >= 1 then
		desc = desc .. " " .. math.floor(secLeft / 60) .. " minutes and"
		secLeft = secLeft - math.floor(secLeft / 60) * 60
	end

	if secLeft < 60 then
		desc = desc .. " " .. secLeft .. " seconds."
	end
	return desc
end

function ForgeMonster:getTimeLeftToChangeMonster(creature)
	local monster = Monster(creature)
	if monster then
		local leftTime = monster:getTimeToChangeFiendish()
		leftTime = leftTime or 0
		return getFiendishMinutesLeft(leftTime)
	end
	return 0
end

function ForgeMonster:onDeath(creature, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if not creature then
		return true
	end

	local stack = creature:getForgeStack()
	if stack > 0 then
		local party = nil
		if killer then
			if killer:isPlayer() then
				party = killer:getParty()
			elseif killer:getMaster() and killer:getMaster():isPlayer() then
				party = killer:getMaster():getParty()
			end
		end

		if party and party:isSharedExperienceEnabled() then
			local killers = {}
			local partyMembers = party:getMembers()

			for pid, _ in pairs(creature:getDamageMap()) do
				local creatureKiller = Creature(pid)
				if creatureKiller and creatureKiller:isPlayer() then
					if not isInArray(killers, creatureKiller) and isInArray(partyMembers, creatureKiller) then
						table.insert(killers, creatureKiller)
					end
				end
			end

			for i = 1, #killers do
				local playerKiller = killers[i]
				if playerKiller then
					-- Each stack can multiplied from 1x to 3x
					-- Example monster with 5 stack and system randomize multiplier 3x, players will receive 15x dusts

					local amount = math.random(stack, 3 * stack)

					local totalDusts = playerKiller:getForgeDusts()
					local limitDusts = playerKiller:getForgeDustLevel()

					if totalDusts < limitDusts then
						if totalDusts + amount > limitDusts then
							playerKiller:addForgeDusts(limitDusts - totalDusts)
						else
							playerKiller:addForgeDusts(amount)
						end

						local actualTotalDusts = playerKiller:getForgeDusts()
						playerKiller:sendTextMessage(MESSAGE_EVENT_ADVANCE,
						"You received " .. amount .. " dust" ..
						" for the Exaltation Forge. You now have " .. actualTotalDusts .. " out of a maximum of " ..
						limitDusts .. " dusts.")
					else
						playerKiller:sendTextMessage(MESSAGE_EVENT_ADVANCE,
						"You did not receive " .. amount .. " dust" ..
						" for the Exaltation Forge because you have already reached the maximum of " .. limitDusts .. " dust.")
					end
				end
			end
		else
			local playerKiller = nil

			if killer then
				if killer:isPlayer() then
					playerKiller = killer
				elseif killer:getMaster() and killer:getMaster():isPlayer() then
					playerKiller = killer:getMaster()
				end
			end

			if playerKiller then
				-- Each stack can multiplied from 1x to 3x
				-- Example monster with 5 stack and system randomize multiplier 3x, players will receive 15x dusts

				local amount = math.random(stack, 3 * stack)

				local totalDusts = playerKiller:getForgeDusts()
				local limitDusts = playerKiller:getForgeDustLevel()

				if totalDusts < limitDusts then
					if totalDusts + amount > limitDusts then
						playerKiller:addForgeDusts(limitDusts - totalDusts)
					else
						playerKiller:addForgeDusts(amount)
					end

					local actualTotalDusts = playerKiller:getForgeDusts()
					playerKiller:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					"You received " .. amount .. " dust" ..
					" for the Exaltation Forge. You now have " .. actualTotalDusts .. " out of a maximum of " ..
					limitDusts .. " dusts.")
				else
					playerKiller:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					"You did not receive " .. amount .. " dust" ..
					" for the Exaltation Forge because you have already reached the maximum of " .. limitDusts .. " dust.")
				end
			end
		end
	end
	return true
end

function ForgeMonster:onSpawn(creature)
	local monster = Monster(creature)
	if not monster then
		return false
	end

	local monsterType = monster:getType()
	if not monsterType then
		return false
	end

	local pos = monster:getPosition()
	local tile = Tile(pos)
	if tile and tile:hasFlag(TILESTATE_NOLOGOUT) then
		return false
	end

	Game.addInfluencedMonster(monster)
end

function ForgeMonster:pickFiendish()
	for _, cid in pairs(Game.getFiendishMonsters()) do
		if Monster(cid) then
			return cid
		end
	end
	return 0
end

function ForgeMonster:pickInfluenced()
	for _, cid in pairs(Game.getInfluencedMonsters()) do
		if Monster(cid) then
			return cid
		end
	end
	return 0
end

function ForgeMonster:pickClosestFiendish(creature)
	local player = Player(creature)
	if not player then
		return 0
	end

	local creatures = {}

	local playerPosition = player:getPosition()
	for _, cid in pairs(Game.getFiendishMonsters()) do
		if (Monster(cid)) then
			creatures[#creatures + 1] = {cid = cid, distance = Monster(cid):getPosition():getDistance(playerPosition)}
		end
	end

	if (#creatures == 0) then
		return false
	end

	table.sort(creatures, function(a, b)
		return a.distance < b.distance
	end)
	return creatures[1].cid
end

function ForgeMonster:exceededMaxInfluencedMonsters()
	local totalMonsters = 0
	for _, cid in pairs(Game.getInfluencedMonsters()) do
		if Monster(cid) then
			totalMonsters = totalMonsters + 1
		end
	end
	local configMaxMonsters = configManager.getNumber(configKeys.FORGE_INFLUENCED_CREATURES_LIMIT)
	if totalMonsters >= configMaxMonsters then
		return true
	end
	return false
end

local zoneEvent = ZoneEvent(SoulPit.zone)
function zoneEvent.afterLeave(zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if table.empty(zone:getPlayers()) then
		if SoulPit.encounter then
			SoulPit.encounter:reset()
			SoulPit.encounter = nil
		end
	end

	for abilityName, abilityInfo in pairs(SoulPit.bossAbilities) do
		if abilityInfo.player then
			player:unregisterEvent(abilityName)
		end
	end
end
zoneEvent:register()

local soulPitAction = Action()
function soulPitAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or target:getId() ~= 49174 then
		return false
	end

	local isParticipant = false
	for _, v in ipairs(SoulPit.playerPositions) do
		if Position(v.pos) == player:getPosition() then
			isParticipant = true
		end
	end

	if not isParticipant then
		return false
	end

	local lever = Lever()
	lever:setPositions(SoulPit.playerPositions)
	lever:setCondition(function(creature)
		if not creature or not creature:isPlayer() then
			return true
		end

		if not table.empty(SoulPit.zone:getPlayers()) then
			local message = "Someone is fighting in the arena!"
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return false
		end

		local isAccountNormal = creature:getAccountType() < ACCOUNT_TYPE_GAMEMASTER
		if isAccountNormal and creature:getLevel() < SoulPit.requiredLevel then
			local message = string.format("All players need to be level %s or higher.", SoulPit.requiredLevel)
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return false
		end

		local infoPositions = lever:getInfoPositions()
		return true
	end)
	lever:checkPositions()
	if lever:checkConditions() then
		lever:teleportPlayers()
	end

	local monsterName = string.gsub(item:getName(), " soul core", "")

	logger.warn("monster name: " .. monsterName)

	SoulPit.zone:removeMonsters()

	if SoulPit.encounter ~= nil then
		SoulPit.encounter:reset()
	end

	local encounter = Encounter("Soulpit", {
		zone = SoulPit.zone,
	})

	SoulPit.encounter = encounter

	local function waveStart()
		for stack, amount in pairs(SoulPit.waves[encounter.currentStage].stacks) do
			logger.warn("stack: " .. stack)
			logger.warn("amount: " .. amount)
			for i = 1, amount do
				local position = stack ~= 40 and SoulPit.zone:randomPosition() or SoulPit.bossPosition
				for i = 1, SoulPit.timeToSpawnMonsters / 1000 do
					encounter:addEvent(function(position)
						position:sendMagicEffect(SoulPit.effects[stack])
					end, i * 1000, position)
				end

				local randomAbility = SoulPit.possibleAbilities[math.random(1, #SoulPit.possibleAbilities)]
				local chosenBossAbility = SoulPit.bossAbilities[randomAbility]

				encounter:addEvent(function(name, stack, position, bossAbilityName, bossAbility)
					local monster = Game.createSoulPitMonster(name, position, stack)
					if not monster then
						return false
					end
					if stack == 40 then
						logger.warn("ability name: {}", bossAbilityName)
						if bossAbility.monster then
							monster:registerEvent(bossAbilityName)
						end
						if bossAbility.player then
							player:registerEvent(bossAbilityName)
						end
					end
				end, SoulPit.timeToSpawnMonsters, monsterName, stack, position, randomAbility, chosenBossAbility)
			end
		end
	end

	for i = 1, #SoulPit.waves do
		encounter
			:addStage({
				start = waveStart,
			})
			:autoAdvance({ delay = SoulPit.checkMonstersDelay, monstersKilled = true })
	end

	function encounter:onReset(position)
		SoulPit.zone:removeMonsters()

		for _, player in pairs(SoulPit.zone:getPlayers()) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have defeated the core of the %s soul and unlocked its animus mastery!", monsterName))
			-- Add the monster animus mastery for the player.
		end

		addEvent(function()
			SoulPit.encounter = nil
			for _, player in pairs(SoulPit.zone:getPlayers()) do
				player:teleportTo(SoulPit.exit)
			end
		end, SoulPit.timeToKick)
	end

	encounter:start()
	encounter:register()

	return true
end

for _, itemType in pairs(SoulPit.soulCores) do
	soulPitAction:id(itemType:getId())
end
soulPitAction:register()

SoulPit.zone:blockFamiliars()

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
		if SoulPit.kickEvent then
			stopEvent(SoulPit.kickEvent)
			SoulPit.obeliskPosition:transformItem(SoulPit.obeliskActive, SoulPit.obeliskInactive)
		end
	end
end
zoneEvent:register()

local soulPitAction = Action()
function soulPitAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if SoulPit.onFuseSoulCores(player, item, target) then
		return true
	end

	if target and target:getId() == SoulPit.obeliskActive then
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting in the soulpit!")
		return false
	end
	if not target or target:getId() ~= SoulPit.obeliskInactive then
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

		local isAccountNormal = creature:getAccountType() < ACCOUNT_TYPE_GAMEMASTER
		if isAccountNormal and creature:getLevel() < SoulPit.requiredLevel then
			local message = string.format("All players need to be level %s or higher.", SoulPit.requiredLevel)
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return false
		end

		return true
	end)

	lever:checkPositions()
	if not lever:checkConditions() then
		return true
	end

	item:remove(1)

	if SoulPit.kickEvent then
		stopEvent(SoulPit.kickEvent)
	end

	lever:teleportPlayers()
	SoulPit.obeliskPosition:transformItem(SoulPit.obeliskInactive, SoulPit.obeliskActive)
	SoulPit.kickEvent = addEvent(function()
		SoulPit.kickEvent = nil
		SoulPit.encounter = nil
		SoulPit.zone:removePlayers()
		SoulPit.obeliskPosition:transformItem(SoulPit.obeliskActive, SoulPit.obeliskInactive)
	end, SoulPit.timeToKick)

	local monsterName = string.gsub(item:getName(), " soul core", "")
	local monsterVariationName = SoulPit.getMonsterVariationNameBySoulCore(item:getName())
	monsterName = monsterVariationName and monsterVariationName or monsterName

	SoulPit.zone:removeMonsters()

	if SoulPit.encounter ~= nil then
		SoulPit.encounter:reset()
	end

	local encounter = Encounter("Soulpit", {
		zone = SoulPit.zone,
	})

	function encounter:onReset(position)
		SoulPit.zone:removeMonsters()

		for _, player in pairs(SoulPit.zone:getPlayers()) do
			player:addAnimusMastery(monsterName)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have defeated the core of the %s soul and unlocked its animus mastery!", monsterName))
		end

		SoulPit.zone:removePlayers()
	end

	SoulPit.encounter = encounter

	local function waveStart()
		for stack, amount in pairs(SoulPit.waves[encounter.currentStage].stacks) do
			for i = 1, amount do
				local position = stack ~= 40 and SoulPit.zone:randomPosition() or SoulPit.bossPosition
				for i = 1, SoulPit.timeToSpawnMonsters / 1000 do
					encounter:addEvent(function(position)
						local effect = SoulPit.effects[stack]
						if effect then
							position:sendMagicEffect(effect)
						end
					end, i * 1000, position)
				end

				local randomAbility = SoulPit.possibleAbilities[math.random(1, #SoulPit.possibleAbilities)]
				local chosenBossAbility = SoulPit.bossAbilities[randomAbility]

				encounter:addEvent(function(name, stack, position, bossAbilityName, bossAbility)
					local monster = Game.createSoulPitMonster(name, position, stack)
					if not monster then
						return false
					end

					if stack ~= 40 then
						return false
					end

					bossAbility.apply(monster)
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

	encounter:start()
	encounter:register()

	return true
end

for _, itemType in pairs(SoulPit.soulCores) do
	if itemType:getId() ~= 49164 then -- Exclude soul prism
		soulPitAction:id(itemType:getId())
	end
end
soulPitAction:register()

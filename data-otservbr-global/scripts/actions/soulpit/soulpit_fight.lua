local config = {
	soulCores = Game.getSoulCoreItems(),
	requiredLevel = 8,
	playerPositions = {
		{ pos = Position(32371, 31155, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31156, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31157, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31158, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31159, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
	},
	waves = {
		[1] = {
			stacks = {
				[1] = 7,
			},
		},
		[2] = {
			stacks = {
				[1] = 4,
				[5] = 3,
			},
		},
		[3] = {
			stacks = {
				[1] = 5,
				[15] = 2,
			},
		},
		[4] = {
			stacks = {
				[1] = 3,
				[5] = 3,
				[40] = 1,
			},
		},
	},
	effects = {
		[1] = CONST_ME_TELEPORT,
		[5] = CONST_ME_ORANGETELEPORT,
		[15] = CONST_ME_REDTELEPORT,
		[40] = CONST_ME_PURPLETELEPORT,
	},
	bossAbilitiesIndexes = {},
	bossAbilities = {
		["enrage"] = {
			monsterEvents = {
				"enrageSoulPit",
			},
		},
		["opressor"] = {
			spells = {
				{ name = "soulpit opressor", interval = 2000, chance = 25, minDamage = 0, maxDamage = 0 },
				{ name = "soulpit powerless", interval = 2000, chance = 30, minDamage = 0, maxDamage = 0 },
				{ name = "soulpit hexer", interval = 2000, chance = 15, minDamage = 0, maxDamage = 0 },
			},
		},
		["overpower"] = {
			playerEvents = {
				"overpowerSoulPit"
			},
		},
	},
	checkMonstersDelay = 4.5 * 1000, -- 4.5 seconds | The check delay should never be less than the timeToSpawnMonsters.
	timeToSpawnMonsters = 4 * 1000, -- 4 seconds
	totalMonsters = 7,
	bossPosition = Position(32372, 31135, 8),
	exit = Position(32371, 31164, 8),
	zone = Zone("soulpit"),
}

for name, _ in pairs(config.bossAbilities) do
	table.insert(config.bossAbilitiesIndexes, name)
	logger.warn(name)
end

config.zone:addArea(Position(32365, 31134, 8), Position(32382, 31152, 8))

local enrage = CreatureEvent("enrageSoulPit")
function enrage.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if not creature or not creature:isMonster() then
		return true
	end

	local healthPercentage = creature:getHealth() / creature:getMaxHealth()

	if healthPercentage >= 0.5 and healthPercentage <= 0.7 then
		primaryDamage = primaryDamage * 0.9 -- 10% damage reduction
		secondaryDamage = secondaryDamage * 0.9 -- 10% damage reduction
	elseif healthPercentage >= 0.3 and healthPercentage < 0.5 then
		primaryDamage = primaryDamage * 0.75 -- 25% damage reduction
		secondaryDamage = secondaryDamage * 0.75 -- 25% damage reduction
	elseif healthPercentage > 0 and healthPercentage < 0.3 then
		primaryDamage = primaryDamage * 0.6 -- 40% damage reduction
		secondaryDamage = secondaryDamage * 0.6 -- 40% damage reduction
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
enrage:register()

local overpower = CreatureEvent("overpowerSoulPit")
function overpower.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if attacker:getForgeStack() == 40 then
		primaryDamage = primaryDamage * 1.1
		secondaryDamage = secondaryDamage * 1.1
		creature:getPosition():sendMagicEffect(CONST_ME_CRITICAL_DAMAGE)
	end

	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
overpower:register()

local soulPitAction = Action()
function soulPitAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or target:getId() ~= 49174 then
		return false
	end

	local isParticipant = false
	for _, v in ipairs(config.playerPositions) do
		if Position(v.pos) == player:getPosition() then
			isParticipant = true
		end
	end

	if not isParticipant then
		return false
	end

	local lever = Lever()
	lever:setPositions(config.playerPositions)
	lever:setCondition(function(creature)
		if not creature or not creature:isPlayer() then
			return true
		end

		local isAccountNormal = creature:getAccountType() < ACCOUNT_TYPE_GAMEMASTER
		if isAccountNormal and creature:getLevel() < config.requiredLevel then
			local message = "All players need to be level " .. config.requiredLevel .. " or higher."
			creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
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

	config.zone:removeMonsters()

	local encounter = Encounter("Soulpit", {
		zone = config.zone,
	})

	local function waveStart()
		for stack, amount in pairs(config.waves[encounter.currentStage].stacks) do
			logger.warn("stack: " .. stack)
			logger.warn("amount: " .. amount)
			for i = 1, amount do
				local position = stack ~= 40 and config.zone:randomPosition() or config.bossPosition
				for i = 1, config.timeToSpawnMonsters / 1000 do
					encounter:addEvent(function(position)
						position:sendMagicEffect(config.effects[stack])
					end, i * 1000, position)
				end

				encounter:addEvent(function(name, stack, position)
					local monster = Game.createMonster(name, position)
					if not monster then
						return false
					end
					monster:setForgeStack(stack)
					local icon = stack <= 15 and CreatureIconModifications_ReducedHealth or CreatureIconModifications_ReducedHealthExclamation
					monster:removeIcon("forge")
					monster:setIcon("soulpit", CreatureIconCategory_Modifications, icon, stack <= 15 and stack or 0)
					monster:setDropLoot(false)
					if stack == 40 then
						local monsterType = monster:getType()
						local randomAbility = bossAbilitiesIndexes[math.random(#bossAbilitiesIndexes)]
						logger.warn("the random ability chosen was: " .. randomAbility)
						for _, ability in pairs(config.bossAbilities[randomAbility]) do
							if ability.spells then
								for _, spell in pairs(ability.spells) do
									monsterType:addAttack(readSpell(spell, monsterType))
								end
							end
							if ability.monsterEvents then
								for _, name in pairs(ability.monsterEvents) do
									monster:registerEvent(name)
								end
							end
							if ability.playerEvents then
								for _, name in pairs(ability.playerEvents) do
									for _, players in pairs(config.zone:getPlayers()) do
										player:registerEvent(name)
									end
								end
							end
						end
					end
				end, config.timeToSpawnMonsters, monsterName, stack, position)
			end
		end
	end

	for i = 1, #config.waves do
		encounter
			:addStage({
				start = waveStart,
			})
			:autoAdvance({ delay = config.checkMonstersDelay, monstersKilled = true })
	end

	function encounter:onReset(position)
		for _, player in pairs(config.zone:getPlayers()) do
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have defeated the core of the %s soul and unlocked its animus mastery!", monsterName))
			player:teleportTo(config.exit)
			for abilityName, abilities in pairs(config.bossAbilities) do
				if abilities.playerEvents then
					for _, eventName in pairs(abilities.playerEvents) do
						player:registerEvent(eventName)
					end
				end
			end
		end
	end

	encounter:start()
	encounter:register()

	return true
end

for _, itemType in pairs(config.soulCores) do
	soulPitAction:id(itemType:getId())
end
soulPitAction:register()

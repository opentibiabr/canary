SoulPit = {
	registeredMonstersSpell = {},
	SoulCoresConfiguration = {
		chanceToGetSameMonsterSoulCore = 30, -- 30%
		chanceToDropSoulCore = 50, -- 50%
		chanceToGetOminousSoulCore = 5, -- 5%
		monsterVariationsSoulCore = {
			["Horse"] = "horse soul core (taupe)",
			["Brown Horse"] = "horse soul core (brown)",
			["Grey Horse"] = "horse soul core (gray)",
			["Nomad"] = "nomad soul core (basic)",
			["Nomad Blue"] = "nomad soul core (blue)",
			["Nomad Female"] = "nomad soul core (female)",
			["Purple Butterfly"] = "butterfly soul core (purple)",
			["Butterfly"] = "butterfly soul core (blue)",
			["Blue Butterfly"] = "butterfly soul core (blue)",
			["Red Butterfly"] = "butterfly soul core (red)",
		},
		monstersDifficulties = {
			["Harmless"] = 1,
			["Trivial"] = 2,
			["Easy"] = 3,
			["Medium"] = 4,
			["Hard"] = 5,
			["Challenge"] = 6,
		},
	},
	encounter = nil,
	kickEvent = nil,
	soulCores = Game.getSoulCoreItems(),
	requiredLevel = 8,
	playerPositions = {
		{
			pos = Position(32371, 31155, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31156, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31157, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31158, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31159, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
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
	possibleAbilities = {
		"overpowerSoulPit",
		"enrageSoulPit",
		"opressorSoulPit",
	},
	bossAbilities = {
		overpowerSoulPit = {
			criticalChance = 50, -- 50%
			criticalDamage = 25, -- 25%
			apply = function(monster)
				monster:criticalChance(SoulPit.bossAbilities.overpowerSoulPit.criticalChance)
				monster:criticalDamage(SoulPit.bossAbilities.overpowerSoulPit.criticalDamage)
			end,
		},
		enrageSoulPit = {
			bounds = {
				[{ 0.8, 0.6 }] = 0.9, -- 10% damage reduction
				[{ 0.6, 0.4 }] = 0.75, -- 25% damage reduction
				[{ 0.4, 0.2 }] = 0.6, -- 40% damage reduction
				[{ 0.0, 0.2 }] = 0.4, -- 60% damage reduction
			},
			apply = function(monster)
				monster:registerEvent("enrageSoulPit")
			end,
		},
		opressorSoulPit = {
			spells = {
				{ name = "soulpit opressor", interval = 2000, chance = 25, minDamage = 0, maxDamage = 0 },
				{ name = "soulpit powerless", interval = 2000, chance = 30, minDamage = 0, maxDamage = 0 },
				{ name = "soulpit intensehex", interval = 2000, chance = 15, minDamage = 0, maxDamage = 0 },
			},
			apply = function(monster)
				monster:registerEvent("opressorSoulPit")
				local monsterType = monster:getType()
				local monsterTypeName = monsterType:name()

				-- Checking spells
				if SoulPit.registeredMonstersSpell[monsterTypeName] then
					return true
				end

				-- Applying spells
				for _, spell in pairs(SoulPit.bossAbilities.opressorSoulPit.spells) do
					monsterType:addAttack(readSpell(spell, monsterType))
				end

				SoulPit.registeredMonstersSpell[monsterTypeName] = true

				return true
			end,
		},
	},
	timeToKick = 10 * 60 * 1000, -- 10 minutes
	checkMonstersDelay = 4.5 * 1000, -- 4.5 seconds | The check delay should never be less than the timeToSpawnMonsters.
	timeToSpawnMonsters = 4 * 1000, -- 4 seconds
	totalMonsters = 7,
	obeliskActive = 49175,
	obeliskInactive = 49174,
	obeliskPosition = Position(32371, 31154, 8),
	bossPosition = Position(32372, 31135, 8),
	exit = Position(32371, 31164, 8),
	zone = Zone("soulpit"),

	getMonsterVariationNameBySoulCore = function(searchName)
		for mTypeName, soulCoreName in pairs(SoulPit.SoulCoresConfiguration.monsterVariationsSoulCore) do
			if soulCoreName == searchName then
				return mTypeName
			end
		end

		return nil
	end,
	getSoulCoreMonster = function(name)
		return name:match("^(.-) soul core")
	end,
	onFuseSoulCores = function(player, item, target)
		local itemName = item:getName()
		local targetItemName = target:getName()

		if SoulPit.getSoulCoreMonster(itemName) and SoulPit.getSoulCoreMonster(targetItemName) then
			local randomSoulCore = SoulPit.soulCores[math.random(#SoulPit.soulCores)]
			player:addItem(randomSoulCore:getId(), 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have received a %s soul core.", randomSoulCore:getName()))
			item:remove(1)
			target:remove(1)
			return true
		end

		return false
	end,
}

SoulPit.zone:addArea(Position(32365, 31134, 8), Position(32382, 31152, 8))
SoulPit.zone:setRemoveDestination(SoulPit.exit)

SoulPit = {
	SoulCoresConfiguration = {
		chanceToGetSameMonsterSoulCore = 15, -- 15%
		chanceToDropSoulCore = 5, -- 5%
		chanceToGetOminousSoulCore = 2, -- 2%
		chanceToDropSoulPrism = 4, -- 4%
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
			pos = Position(32375, 31158, 8),
			teleport = Position(32373, 31151, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32375, 31159, 8),
			teleport = Position(32374, 31151, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32375, 31160, 8),
			teleport = Position(32375, 31151, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32375, 31161, 8),
			teleport = Position(32376, 31151, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32375, 31162, 8),
			teleport = Position(32377, 31151, 8),
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
				-- Applying spells
				for _, spell in pairs(SoulPit.bossAbilities.opressorSoulPit.spells) do
					monster:addAttackSpell(readSpell(spell, monster:getType()))
				end

				return true
			end,
		},
	},
	timeToKick = 10 * 60 * 1000, -- 10 minutes
	checkMonstersDelay = 4.5 * 1000, -- 4.5 seconds | The check delay should never be less than the timeToSpawnMonsters.
	timeToSpawnMonsters = 4 * 1000, -- 4 seconds
	totalMonsters = 7,
	obeliskActive = 47379,
	obeliskInactive = 47367,
	obeliskPosition = Position(32375, 31157, 8),
	bossPosition = Position(32376, 31144, 8),
	exit = Position(32373, 31158, 8),
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
		local itemCount = item:getCount(item:getId())
		if item:getId() == target:getId() and itemCount <= 1 then
			return false
		end

		local itemSoulCore = SoulPit.getSoulCoreMonster(item:getName())
		local targetSoulCore = SoulPit.getSoulCoreMonster(target:getName())
		if not itemSoulCore or not targetSoulCore then
			return false
		end

		local randomSoulCore = SoulPit.soulCores[math.random(#SoulPit.soulCores)]
		player:addItem(randomSoulCore:getId(), 1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have received a %s soul core.", randomSoulCore:getName()))

		item:remove(1)
		target:remove(1)
		return true
	end,
}

SoulPit.zone:addArea(Position(32362, 31132, 8), Position(32390, 31153, 8))
SoulPit.zone:setRemoveDestination(SoulPit.exit)

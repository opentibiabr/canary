local mType = Game.createMonsterType("Candy Horror")
local monster = {}

monster.description = "a candy horror"
monster.experience = 3000
monster.outfit = {
	lookType = 1739,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {}

monster.raceId = 2535
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Chocolate Mines.",
}

monster.health = 3100
monster.maxHealth = 3100
monster.race = "blood"
monster.corpse = 48267
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We will devour you ...", yell = false },
	{ text = "Wait for us, little treat ...", yell = false },
	{ text = "*Horrraa!", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 30 },
	{ name = "platinum coin", chance = 82000, maxCount = 6 },
	{ id = 281, chance = 6510 }, -- giant shimmering pearl (green)
	{ id = 3591, chance = 1400, maxCount = 2 }, -- stawberries
	{ id = 48250, chance = 440, maxCount = 11 }, -- dark chocolate coin
	{ id = 48116, chance = 2490, maxCount = 2 }, -- gummy rotworm
	{ id = 3036, chance = 1550 }, -- violet gem
	{ id = 48252, chance = 1250 }, -- brigadeiro
	{ id = 23535, chance = 5550 }, -- energy bar
	{ id = 8012, chance = 1240, maxCount = 2 }, -- raspberry
	{ id = 7419, chance = 502 }, -- dreaded cleaver
	{ id = 3072, chance = 1840 }, -- wand of decay
	{ id = 3429, chance = 2830 }, -- black shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -120, maxDamage = -300, range = 6, radius = 3, effect = CONST_ME_CAKE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -120, maxDamage = -350, radius = 6, effect = CONST_ME_CACAO, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -350, effect = CONST_ME_BIG_SCRATCH, target = false },
}

monster.defenses = {
	defense = 24,
	armor = 43,
	mitigation = 1.21,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

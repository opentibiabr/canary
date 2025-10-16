local mType = Game.createMonsterType("Hive Overseer")
local monster = {}

monster.description = "a hive overseer"
monster.experience = 5500
monster.outfit = {
	lookType = 458,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 801
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 2,
	Locations = "The Hive towers: on the highest floor of each tower, \z
		and in many of the closed rooms accessed with pheromones; \z
		many in the large underground room of the west tower. \z
	Liberty Bay Hive Outpost: one spawn on the second floor underground.",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "venom"
monster.corpse = 13937
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 95,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Spidris Elite Summon", chance = 40, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Zopp!", yell = false },
	{ text = "Kropp!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 198 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 6 }, -- platinum coin
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 14077, chance = 80000 }, -- kollos shell
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 14083, chance = 23000 }, -- compound eye
	{ id = 3030, chance = 23000, maxCount = 2 }, -- small ruby
	{ id = 14172, chance = 23000, maxCount = 2 }, -- gooey mass
	{ id = 7643, chance = 23000 }, -- ultimate health potion
	{ id = 14086, chance = 5000 }, -- calopteryx cape
	{ id = 14089, chance = 5000 }, -- hive scythe
	{ id = 14088, chance = 1000 }, -- carapace shield
	{ id = 14246, chance = 1000 }, -- hive bow
	{ id = 3554, chance = 260 }, -- steel boots
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -80, radius = 4, effect = CONST_ME_POISONAREA, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -600, maxDamage = -1000, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 57,
	mitigation = 2.40,
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

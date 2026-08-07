local mType = Game.createMonsterType("Breach Brood")
local monster = {}

monster.description = "a breach brood"
monster.experience = 1760
monster.outfit = {
	lookType = 878,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1235
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Otherworld.",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "venom"
monster.corpse = 23392
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	canWalkOnEnergy = true,
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
	{ text = "Hisss!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 23545, chance = 18500 }, -- Energy Drink
	{ id = 23535, chance = 17800 }, -- Energy Bar
	{ id = 23518, chance = 14700 }, -- Spark Sphere
	{ id = 239, chance = 12600 }, -- Great Health Potion
	{ id = 238, chance = 12500 }, -- Great Mana Potion
	{ id = 7642, chance = 11200 }, -- Great Spirit Potion
	{ id = 23506, chance = 10800 }, -- Plasma Pearls
	{ id = 23514, chance = 10500 }, -- Volatile Proto Matter
	{ id = 23507, chance = 9500 }, -- Crystallized Anger
	{ id = 23511, chance = 9200 }, -- Curious Matter
	{ id = 16124, chance = 7700, maxCount = 2 }, -- Blue Crystal Splinter
	{ id = 16125, chance = 5700 }, -- Cyan Crystal Fragment
	{ id = 16121, chance = 4200 }, -- Green Crystal Shard
	{ id = 16119, chance = 3800 }, -- Blue Crystal Shard
	{ id = 3041, chance = 370 }, -- Blue Gem
	{ id = 23529, chance = 280 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 280 }, -- Ring of Green Plasma
	{ id = 23533, chance = 230 }, -- Ring of Red Plasma
	{ id = 23543, chance = 170 }, -- Collar of Green Plasma
	{ id = 23544, chance = 170 }, -- Collar of Red Plasma
	{ id = 50150, chance = 170 }, -- Ring of Orange Plasma
	{ id = 23526, chance = 85 }, -- Collar of Blue Plasma
	{ id = 50152, chance = 85 }, -- Collar of Orange Plasma
	{ id = 822, chance = 85 }, -- Lightning Legs
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -400, range = 6, shootEffect = CONST_ANI_FLASHARROW, effect = CONST_ME_STUN, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -150, maxDamage = -350, radius = 5, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "breach brood reducer", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 52,
	armor = 53,
	mitigation = 1.46,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

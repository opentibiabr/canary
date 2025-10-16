local mType = Game.createMonsterType("Young Goanna")
local monster = {}

monster.description = "a young goanna"
monster.experience = 6100
monster.outfit = {
	lookType = 1196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1817
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt.",
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "blood"
monster.corpse = 31409
monster.speed = 190
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 3 }, -- platinum coin
	{ id = 16143, chance = 80000, maxCount = 35 }, -- envenomed arrow
	{ id = 3065, chance = 23000 }, -- terra rod
	{ id = 31560, chance = 23000 }, -- goanna meat
	{ id = 3066, chance = 23000 }, -- snakebite rod
	{ id = 31559, chance = 23000 }, -- blue goanna scale
	{ id = 16119, chance = 23000 }, -- blue crystal shard
	{ id = 677, chance = 5000 }, -- small enchanted emerald
	{ id = 814, chance = 5000 }, -- terra amulet
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 31561, chance = 5000 }, -- goanna claw
	{ id = 3297, chance = 5000 }, -- serpent sword
	{ id = 25735, chance = 5000, maxCount = 3 }, -- leaf star
	{ id = 3054, chance = 5000 }, -- silver amulet
	{ id = 8084, chance = 5000 }, -- springsprout rod
	{ id = 31488, chance = 5000 }, -- scared frog
	{ id = 25737, chance = 5000, maxCount = 3 }, -- rainbow quartz
	{ id = 22193, chance = 5000 }, -- onyx chip
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 16124, chance = 5000 }, -- blue crystal splinter
	{ id = 31340, chance = 1000 }, -- lizard heart
	{ id = 9302, chance = 1000 }, -- sacred tree amulet
	{ id = 31445, chance = 1000 }, -- small tortoise
	{ id = 830, chance = 1000 }, -- terra hood
	{ id = 22085, chance = 260 }, -- fur armor
	{ id = 25699, chance = 260 }, -- wooden spellbook
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, condition = { type = CONDITION_POISON, totalDamage = 200, interval = 4000 } },
	{ name = "combat", interval = 2500, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -490, range = 3, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_HITBYPOISON, target = true },
	{ name = "combat", interval = 3000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -500, radius = 1, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 3500, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -490, lenght = 8, spread = 0, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

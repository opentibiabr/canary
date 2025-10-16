local mType = Game.createMonsterType("Oozing Corpus")
local monster = {}

monster.description = "an oozing corpus"
monster.experience = 20600
monster.outfit = {
	lookType = 1625,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2381
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Jaded Roots.",
}

monster.health = 28700
monster.maxHealth = 28700
monster.race = "undead"
monster.corpse = 43575
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 0,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 143,
}

monster.loot = {
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 813, chance = 5000 }, -- terra boots
	{ id = 3033, chance = 5000 }, -- small amethyst
	{ id = 43849, chance = 5000 }, -- rotten roots
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 7430, chance = 5000 }, -- dragonbone staff
	{ id = 43848, chance = 5000 }, -- worm sponge
	{ id = 3036, chance = 1000 }, -- violet gem
	{ id = 7422, chance = 260 }, -- jade hammer
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1600 },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1300, maxDamage = -1700, radius = 5, effect = CONST_ME_GHOSTLY_BITE, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -1400, maxDamage = -1550, length = 8, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -1100, maxDamage = -1550, length = 8, spread = 3, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "death chain", interval = 3000, chance = 15, minDamage = -900, maxDamage = -1300, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 107,
	mitigation = 3.25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

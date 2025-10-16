local mType = Game.createMonsterType("Cult Scholar")
local monster = {}

monster.description = "a cult scholar"
monster.experience = 1100
monster.outfit = {
	lookType = 145,
	lookHead = 19,
	lookBody = 77,
	lookLegs = 3,
	lookFeet = 20,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"CarlinVortexDeath",
}

monster.raceId = 1514
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Forbidden Temple (Carlin).",
}

monster.health = 1650
monster.maxHealth = 1650
monster.race = "blood"
monster.corpse = 22017
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
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
	{ text = "The Secrets are ours alone!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 70 }, -- gold coin
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 9639, chance = 23000 }, -- cultish robe
	{ id = 239, chance = 23000 }, -- great health potion
	{ id = 3033, chance = 5000 }, -- small amethyst
	{ id = 3032, chance = 5000 }, -- small emerald
	{ id = 3028, chance = 5000 }, -- small diamond
	{ id = 3572, chance = 1000 }, -- scarf
	{ id = 3048, chance = 260 }, -- might ring
	{ id = 2995, chance = 260 }, -- piggy bank
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -580 },
}

monster.defenses = {
	defense = 50,
	armor = 30,
	mitigation = 1.18,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 20, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

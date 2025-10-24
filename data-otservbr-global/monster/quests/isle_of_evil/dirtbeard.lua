local mType = Game.createMonsterType("Dirtbeard")
local monster = {}

monster.description = "Dirtbeard"
monster.experience = 375
monster.outfit = {
	lookType = 98,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 565,
	bossRace = RARITY_BANE,
}

monster.health = 630
monster.maxHealth = 630
monster.race = "blood"
monster.corpse = 18197
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 50,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Pirate Marauder", chance = 30, interval = 4000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You are no match for the scourge of the seas!", yell = false },
	{ text = "You move like a seasick whale!", yell = false },
	{ text = "Yarr, death to all landlubbers!", yell = false },
}

monster.loot = {
	{ id = 9374, chance = 1000 }, -- Odd Hat
	{ id = 9401, 9447, chance = 1000 }, -- The Shield Nevermourn
	{ id = 9375, chance = 40000 }, -- Pointed Rabbitslayer
	{ id = 9382, chance = 60000 }, -- Helmet of Nature
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -125 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false },
	{ name = "melee", interval = 2000, chance = 30, minDamage = 0, maxDamage = 0 },
	{ name = "pirate corsair skill reducer", interval = 2000, chance = 5, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 30,
	mitigation = 0.40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

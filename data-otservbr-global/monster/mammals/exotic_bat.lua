local mType = Game.createMonsterType("Exotic Bat")
local monster = {}

monster.description = "a exotic bat"
monster.experience = 1200
monster.outfit = {
	lookType = 1373,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2051
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Exotic cave Spider cave.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "venom"
monster.corpse = 35690
monster.speed = 100
monster.manaCost = 250

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 0,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 4 }, -- platinum coin
	{ id = 238, chance = 80000, maxCount = 2 }, -- great mana potion
	{ id = 814, chance = 23000 }, -- terra amulet
	{ id = 3728, chance = 23000, maxCount = 6 }, -- dark mushroom
	{ id = 3732, chance = 23000, maxCount = 5 }, -- green mushroom
	{ id = 3083, chance = 5000 }, -- garlic necklace
	{ id = 5894, chance = 5000, maxCount = 2 }, -- bat wing
	{ id = 47990, chance = 80000 }, -- exotic bat soul core
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -10, maxDamage = -130 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -90, maxDamage = -170, length = 5, spread = 2, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -70, maxDamage = -170, range = 7, radius = 3, effect = CONST_ME_YELLOW_RINGS, target = true },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.18,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 1 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

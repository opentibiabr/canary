local mType = Game.createMonsterType("Valkyrie")
local monster = {}

monster.description = "a valkyrie"
monster.experience = 85
monster.outfit = {
	lookType = 139,
	lookHead = 113,
	lookBody = 38,
	lookLegs = 76,
	lookFeet = 96,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 12
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Amazon Camp (Venore), Amazon Camp (Carlin), Amazonia, \z
		single respawn to the north west of Thais, Foreigner Quarter in Yalahar.",
}

monster.health = 190
monster.maxHealth = 190
monster.race = "blood"
monster.corpse = 18242
monster.speed = 88
monster.manaCost = 450

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
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
	{ text = "Another head for me!", yell = false },
	{ text = "Head off!", yell = false },
	{ text = "Your head will be mine!", yell = false },
	{ text = "Stand still!", yell = false },
	{ text = "One more head for me!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 32390, maxCount = 12 }, -- Gold Coin
	{ id = 3577, chance = 28002 }, -- Meat
	{ id = 3277, chance = 55220, maxCount = 3 }, -- Spear
	{ id = 3358, chance = 10573 }, -- Chain Armor
	{ id = 3585, chance = 10456, maxCount = 2 }, -- Red Apple
	{ id = 11443, chance = 6040 }, -- Girlish Hair Decoration
	{ id = 3084, chance = 1264 }, -- Protection Amulet
	{ id = 3347, chance = 5324 }, -- Hunting Spear
	{ id = 11444, chance = 3180 }, -- Protective Charm
	{ id = 266, chance = 494 }, -- Health Potion
	{ id = 3357, chance = 738 }, -- Plate Armor
	{ id = 3114, chance = 760 }, -- Skull (Item)
	{ id = 3275, chance = 264 }, -- Double Axe
	{ id = 3028, chance = 151 }, -- Small Diamond
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -70 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -50, range = 5, shootEffect = CONST_ANI_SPEAR, target = false },
}

monster.defenses = {
	defense = 12,
	armor = 12,
	mitigation = 0.36,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

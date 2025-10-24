local mType = Game.createMonsterType("Kongra")
local monster = {}

monster.description = "a kongra"
monster.experience = 115
monster.outfit = {
	lookType = 116,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 116
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "In Banuta, northeast of Port Hope, Arena and Zoo Quarter.",
}

monster.health = 340
monster.maxHealth = 340
monster.race = "blood"
monster.corpse = 6043
monster.speed = 92
monster.manaCost = 0

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
	{ text = "Ungh! Ungh!", yell = false },
	{ text = "Hugah!", yell = false },
	{ text = "Huaauaauaauaa!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 88012, maxCount = 40 }, -- Gold Coin
	{ id = 3587, chance = 48632, maxCount = 12 }, -- Banana
	{ id = 11471, chance = 8195 }, -- Kongra's Shoulderpad
	{ id = 5883, chance = 1189 }, -- Ape Fur
	{ id = 266, chance = 541 }, -- Health Potion
	{ id = 3357, chance = 1403 }, -- Plate Armor
	{ id = 3084, chance = 862 }, -- Protection Amulet
	{ id = 3093, chance = 214 }, -- Club Ring
	{ id = 3050, chance = 361 }, -- Power Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -60 },
}

monster.defenses = {
	defense = 20,
	armor = 18,
	mitigation = 0.36,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 260, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

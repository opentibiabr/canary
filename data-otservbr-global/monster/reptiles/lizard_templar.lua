local mType = Game.createMonsterType("Lizard Templar")
local monster = {}

monster.description = "a lizard templar"
monster.experience = 155
monster.outfit = {
	lookType = 113,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 113
monster.Bestiary = {
	class = "Reptile",
	race = BESTY_RACE_REPTILE,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Chor, the lizard city south-east from Port Hope. They can also be found in Yalahar's \z
		Foreigner Quarter and in Zzaion.",
}

monster.health = 410
monster.maxHealth = 410
monster.race = "blood"
monster.corpse = 4239
monster.speed = 87
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Hissss!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 83840, maxCount = 60 }, -- Gold Coin
	{ id = 3294, chance = 9572 }, -- Short Sword
	{ id = 3264, chance = 4457 }, -- Sword
	{ id = 3351, chance = 1996 }, -- Steel Helmet
	{ id = 3282, chance = 1923 }, -- Morning Star
	{ id = 3357, chance = 830 }, -- Plate Armor
	{ id = 5881, chance = 890 }, -- Lizard Scale
	{ id = 5876, chance = 688 }, -- Lizard Leather
	{ id = 266, chance = 953 }, -- Health Potion
	{ id = 3345, chance = 516 }, -- Templar Scytheblade
	{ id = 3032, chance = 519 }, -- Small Emerald
	{ id = 3445, chance = 351 }, -- Salamander Shield
	{ id = 50259, chance = 70 }, -- Zaoan Monk Robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -70 },
}

monster.defenses = {
	defense = 20,
	armor = 26,
	mitigation = 0.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

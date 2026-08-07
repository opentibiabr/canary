local mType = Game.createMonsterType("Water Elemental")
local monster = {}

monster.description = "a water elemental"
monster.experience = 650
monster.outfit = {
	lookType = 286,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 236
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Water Elemental Cave in Port Hope, Water Elemental Dungeon, Deeper Banuta, Malada, Ramoa, \z
		Talahu, Folda (7 spawn on the 3rd floor), Water Elemental Cave in Outlaw Camp (only during the Down the \z
		Drain Mini World Change), Krailos Steppe underwater cave.",
}

monster.health = 550
monster.maxHealth = 550
monster.race = "undead"
monster.corpse = 9582
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 143,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Splish splash", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 24000 }, -- Platinum Coin
	{ id = 3578, chance = 18500 }, -- Fish
	{ id = 237, chance = 11600 }, -- Strong Mana Potion
	{ id = 236, chance = 8800 }, -- Strong Health Potion
	{ id = 3028, chance = 3100 }, -- Small Diamond
	{ id = 3032, chance = 1600, maxCount = 2 }, -- Small Emerald
	{ id = 7158, chance = 1500 }, -- Rainbow Trout
	{ id = 3048, chance = 1100 }, -- Might Ring
	{ id = 7159, chance = 860 }, -- Green Perch
	{ id = 3051, chance = 740 }, -- Energy Ring
	{ id = 3052, chance = 740 }, -- Life Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -160, condition = { type = CONDITION_POISON, totalDamage = 60, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DROWNDAMAGE, minDamage = -125, maxDamage = -235, range = 7, radius = 2, effect = CONST_ME_LOSEENERGY, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -88, maxDamage = -150, range = 7, shootEffect = CONST_ANI_SMALLICE, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -225, maxDamage = -260, radius = 5, effect = CONST_ME_POISONAREA, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 37,
	mitigation = 0.88,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

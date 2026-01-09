local mType = Game.createMonsterType("High Voltage Elemental")
local monster = {}

monster.description = "a high voltage elemental"
monster.experience = 1500
monster.outfit = {
	lookType = 293,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1116
monster.Bestiary = {
	class = "Elemental",
	race = BESTY_RACE_ELEMENTAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "South side of the second floor of Underground Glooth Factory, Warzone 5",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 8138
monster.speed = 139
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 4,
	color = 143,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 189 }, -- Gold Coin
	{ id = 761, chance = 19118, maxCount = 20 }, -- Flash Arrow
	{ id = 7449, chance = 7381 }, -- Crystal Sword
	{ id = 237, chance = 3594 }, -- Strong Mana Potion
	{ id = 268, chance = 5340 }, -- Mana Potion
	{ id = 3007, chance = 4397 }, -- Crystal Ring
	{ id = 3033, chance = 4619, maxCount = 3 }, -- Small Amethyst
	{ id = 3051, chance = 2395 }, -- Energy Ring
	{ id = 3313, chance = 4524 }, -- Obsidian Lance
	{ id = 816, chance = 352 }, -- Lightning Pendant
	{ id = 3073, chance = 531 }, -- Wand of Cosmic Energy
	{ id = 8073, chance = 488 }, -- Spellbook of Warding
	{ id = 3048, chance = 1060 }, -- Might Ring
	{ id = 822, chance = 133 }, -- Lightning Legs
	{ id = 825, chance = 177 }, -- Lightning Robe
	{ id = 828, chance = 110 }, -- Lightning Headband
	{ id = 9304, chance = 206 }, -- Shockwave Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 66, attack = 70 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -205, maxDamage = -497, range = 7, radius = 2, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -201, maxDamage = -277, range = 7, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 11,
	armor = 35,
	mitigation = 1.60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

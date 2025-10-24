local mType = Game.createMonsterType("Dark Magician")
local monster = {}

monster.description = "a dark magician"
monster.experience = 185
monster.outfit = {
	lookType = 133,
	lookHead = 58,
	lookBody = 95,
	lookLegs = 51,
	lookFeet = 131,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 371
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Hero Cave (Edron), Magician Tower, Dark Cathedral and Yalahar Academy of Magic in \z
		Magician Quarter and a single one on The Witches' Cliff (only accessible during a quest).",
}

monster.health = 325
monster.maxHealth = 325
monster.race = "blood"
monster.corpse = 18086
monster.speed = 90
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
	targetDistance = 4,
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
	{ text = "Feel the power of my runes!", yell = false },
	{ text = "Killing you gets expensive.", yell = false },
	{ text = "My secrets are mine alone!", yell = false },
	{ text = "Stand still!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 75000, maxCount = 55 }, -- Gold Coin
	{ id = 3147, chance = 10755 }, -- Blank Rune
	{ id = 266, chance = 12530 }, -- Health Potion
	{ id = 268, chance = 12887 }, -- Mana Potion
	{ id = 236, chance = 3095 }, -- Strong Health Potion
	{ id = 237, chance = 2978 }, -- Strong Mana Potion
	{ id = 678, chance = 330 }, -- Small Enchanted Amethyst
	{ id = 3069, chance = 254 }, -- Necrotic Rod
	{ id = 12308, chance = 20 }, -- Reins
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -40 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -5, maxDamage = -40, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -20, maxDamage = -30, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.64,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 60, maxDamage = 80, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

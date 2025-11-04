local mType = Game.createMonsterType("Werelioness")
local monster = {}

monster.description = "a werelioness"
monster.experience = 2300
monster.outfit = {
	lookType = 1301,
	lookHead = 0,
	lookBody = 2,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1966
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Lion Sanctum.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 34185
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	targetDistance = 1,
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3031, chance = 88940 }, -- Gold Coin
	{ id = 3035, chance = 90101 }, -- Platinum Coin
	{ id = 3582, chance = 73307 }, -- Ham
	{ id = 675, chance = 8461 }, -- Small Enchanted Sapphire
	{ id = 3027, chance = 7060 }, -- Black Pearl
	{ id = 7449, chance = 9354 }, -- Crystal Sword
	{ id = 22083, chance = 1251 }, -- Moonlight Crystals
	{ id = 9691, chance = 14098 }, -- Lion's Mane
	{ id = 3272, chance = 12210 }, -- Rapier
	{ id = 5944, chance = 18125 }, -- Soul Orb
	{ id = 3577, chance = 16831 }, -- Meat
	{ id = 3077, chance = 8691 }, -- Ankh
	{ id = 3355, chance = 10309 }, -- Leather Helmet
	{ id = 3297, chance = 5425 }, -- Serpent Sword
	{ id = 33945, chance = 3100 }, -- Ivory Carving
	{ id = 3026, chance = 3006 }, -- White Pearl
	{ id = 3351, chance = 3441 }, -- Steel Helmet
	{ id = 828, chance = 2010 }, -- Lightning Headband
	{ id = 821, chance = 904 }, -- Magma Legs
	{ id = 3385, chance = 866 }, -- Crown Helmet
	{ id = 33781, chance = 450 }, -- Lion Figurine
	{ id = 34008, chance = 351 }, -- White Silk Flower
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -410, range = 3, effect = CONST_ME_HOLYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HOLYDAMAGE, minDamage = -170, maxDamage = -350, range = 3, shootEffect = CONST_ANI_HOLY, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -250, maxDamage = -300, length = 4, spread = 0, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 38,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

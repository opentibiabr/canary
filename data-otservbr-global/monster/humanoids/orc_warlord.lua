local mType = Game.createMonsterType("Orc Warlord")
local monster = {}

monster.description = "an orc warlord"
monster.experience = 670
monster.outfit = {
	lookType = 2,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Orc Fortress, Foreigner Quarter, Zao Orc Land.",
}

monster.health = 950
monster.maxHealth = 950
monster.race = "blood"
monster.corpse = 6008
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 15,
	damage = 15,
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
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ikem rambo zambo!", yell = false },
	{ text = "Orc buta bana!", yell = false },
	{ text = "Ranat Ulderek!", yell = false },
	{ text = "Futchi maruk buta!", yell = false },
}

monster.loot = {
	{ id = 11453, chance = 25000 }, -- Broken Helmet
	{ id = 11479, chance = 20000 }, -- Orc Leather
	{ id = 3031, chance = 19000, maxCount = 45 }, -- Gold Coin
	{ id = 3287, chance = 15000, maxCount = 18 }, -- Throwing Star
	{ id = 3578, chance = 10400, maxCount = 2 }, -- Fish
	{ id = 10196, chance = 9900 }, -- Orc Tooth
	{ id = 3357, chance = 5700 }, -- Plate Armor
	{ id = 3316, chance = 5200 }, -- Orcish Axe
	{ id = 11480, chance = 5100 }, -- Skull Belt
	{ id = 3347, chance = 5000 }, -- Hunting Spear
	{ id = 3557, chance = 3900 }, -- Plate Legs
	{ id = 3307, chance = 3000 }, -- Scimitar
	{ id = 3084, chance = 1900 }, -- Protection Amulet
	{ id = 3265, chance = 1800 }, -- Two Handed Sword
	{ id = 3384, chance = 1300 }, -- Dark Helmet
	{ id = 3359, chance = 890 }, -- Brass Armor
	{ id = 266, chance = 310 }, -- Health Potion
	{ id = 3391, chance = 280 }, -- Crusader Helmet
	{ id = 3322, chance = 240 }, -- Dragon Hammer
	{ id = 818, chance = 200 }, -- Magma Boots
	{ id = 7395, chance = 140 }, -- Orc Trophy
	{ id = 3049, chance = 110 }, -- Stealth Ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_THROWINGSTAR, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 28,
	mitigation = 1.46,
	{ name = "invisible", interval = 2000, chance = 5, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

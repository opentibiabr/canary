local mType = Game.createMonsterType("Undead Elite Gladiator")
local monster = {}

monster.description = "an undead elite gladiator"
monster.experience = 5090
monster.outfit = {
	lookType = 306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1675
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep Desert.",
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "undead"
monster.corpse = 8909
monster.speed = 150
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 40 }, -- Platinum Coin
	{ id = 8044, chance = 26296 }, -- Belted Cape
	{ id = 3287, chance = 15222, maxCount = 18 }, -- Throwing Star
	{ id = 3307, chance = 10647 }, -- Scimitar
	{ id = 7643, chance = 8331 }, -- Ultimate Health Potion
	{ id = 3318, chance = 8011 }, -- Knight Axe
	{ id = 3557, chance = 5556 }, -- Plate Legs
	{ id = 239, chance = 5101 }, -- Great Health Potion
	{ id = 9656, chance = 5078 }, -- Broken Gladiator Shield
	{ id = 5885, chance = 5051 }, -- Flask of Warrior's Sweat
	{ id = 3357, chance = 2264 }, -- Plate Armor
	{ id = 3347, chance = 5072 }, -- Hunting Spear
	{ id = 3265, chance = 1833 }, -- Two Handed Sword
	{ id = 3084, chance = 2061 }, -- Protection Amulet
	{ id = 3384, chance = 1680 }, -- Dark Helmet
	{ id = 3049, chance = 931 }, -- Stealth Ring
	{ id = 3391, chance = 110 }, -- Crusader Helmet
	{ id = 7383, chance = 318 }, -- Relic Sword
	{ id = 3081, chance = 170 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 100, maxDamage = 550 },
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 300, maxDamage = 550, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 300, maxDamage = 500, range = 5, radius = 3, effect = CONST_ME_HITAREA, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 85,
	mitigation = 2.40,
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE },
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

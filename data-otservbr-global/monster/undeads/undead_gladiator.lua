local mType = Game.createMonsterType("Undead Gladiator")
local monster = {}

monster.description = "an undead gladiator"
monster.experience = 800
monster.outfit = {
	lookType = 306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 508
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Arena and Zoo Quarter, Krailos.",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "undead"
monster.corpse = 8909
monster.speed = 110
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
	{ text = "Let's battle it out in a duel!", yell = false },
	{ text = "Bring it!", yell = false },
	{ text = "I'll fight here in eternity and beyond.", yell = false },
	{ text = "I will not give up!", yell = false },
	{ text = "Another foolish adventurer who tries to beat me.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 95000, maxCount = 148 }, -- Gold Coin
	{ id = 3287, chance = 16800, maxCount = 18 }, -- Throwing Star
	{ id = 3307, chance = 12000 }, -- Scimitar
	{ id = 3347, chance = 5600 }, -- Hunting Spear
	{ id = 3359, chance = 5200 }, -- Brass Armor
	{ id = 3372, chance = 5000 }, -- Brass Legs
	{ id = 8044, chance = 4800 }, -- Belted Cape
	{ id = 9656, chance = 4300 }, -- Broken Gladiator Shield
	{ id = 3265, chance = 2100 }, -- Two Handed Sword
	{ id = 3084, chance = 1900 }, -- Protection Amulet
	{ id = 3357, chance = 1700 }, -- Plate Armor
	{ id = 3384, chance = 1600 }, -- Dark Helmet
	{ id = 3557, chance = 1500 }, -- Plate Legs
	{ id = 266, chance = 1000 }, -- Health Potion
	{ id = 3318, chance = 570 }, -- Knight Axe
	{ id = 5885, chance = 200 }, -- Flask of Warrior's Sweat
	{ id = 3391, chance = 120 }, -- Crusader Helmet
	{ id = 3049, chance = 81 }, -- Stealth Ring
	{ id = 3081, chance = 41 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -135, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 35,
	mitigation = 1.54,
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

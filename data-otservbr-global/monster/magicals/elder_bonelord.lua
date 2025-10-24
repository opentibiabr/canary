local mType = Game.createMonsterType("Elder Bonelord")
local monster = {}

monster.description = "an elder bonelord"
monster.experience = 280
monster.outfit = {
	lookType = 108,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 108
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Hellgate, near the Hellgate Library, Deeper Banuta, behind piano in Cult Cave to the \z
		northeast of Liberty Bay, Vandura Bonelord Cave, Goroma, Helheim, \z
		underground of Fenrock (on the way to Beregar), Vengoth.",
}

monster.health = 500
monster.maxHealth = 500
monster.race = "blood"
monster.corpse = 6037
monster.speed = 85
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 6,
	summons = {
		{ name = "Gazer", chance = 10, interval = 2000, count = 6 },
		{ name = "Crypt Shambler", chance = 15, interval = 2000, count = 6 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Inferior creatures, bow before my power!", yell = false },
	{ text = "Let me take a look at you!", yell = false },
	{ text = "659978 54764!", yell = false },
	{ text = "653768764!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 99306, maxCount = 90 }, -- Gold Coin
	{ id = 7364, chance = 11577, maxCount = 4 }, -- Sniper Arrow
	{ id = 10276, chance = 20122 }, -- Elder Bonelord Tentacle
	{ id = 11512, chance = 9770 }, -- Small Flask of Eyedrops
	{ id = 3265, chance = 3416 }, -- Two Handed Sword
	{ id = 3409, chance = 2439 }, -- Steel Shield
	{ id = 5898, chance = 1919 }, -- Bonelord Eye
	{ id = 237, chance = 806 }, -- Strong Mana Potion
	{ id = 3059, chance = 1073 }, -- Spellbook
	{ id = 10280, chance = 505 }, -- Giant Eye
	{ id = 3408, chance = 93 }, -- Bonelord Helmet
	{ id = 3418, chance = 90 }, -- Bonelord Shield
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -55 },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_ENERGYDAMAGE, minDamage = -45, maxDamage = -60, range = 7, shootEffect = CONST_ANI_ENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_FIREDAMAGE, minDamage = -40, maxDamage = -80, range = 7, shootEffect = CONST_ANI_FIRE, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -45, maxDamage = -90, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -20, maxDamage = -40, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_LIFEDRAIN, minDamage = -45, maxDamage = -85, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -40, range = 7, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 13,
	armor = 13,
	mitigation = 0.67,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

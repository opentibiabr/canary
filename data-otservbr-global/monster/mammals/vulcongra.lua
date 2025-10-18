local mType = Game.createMonsterType("Vulcongra")
local monster = {}

monster.description = "a vulcongra"
monster.experience = 1100
monster.outfit = {
	lookType = 509,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 898
monster.Bestiary = {
	class = "Mammal",
	race = BESTY_RACE_MAMMAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Hot Spot (in Gnomebase Alpha) and Lower Spike.",
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "fire"
monster.corpse = 16186
monster.speed = 160
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 220,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Fuchah!", yell = false },
	{ text = "Fuchah! Fuchah!", yell = false },
	{ text = "Yag! Yag! Yag!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 107 }, -- Gold Coin
	{ id = 3035, chance = 14490 }, -- Platinum Coin
	{ id = 3587, chance = 9660, maxCount = 10 }, -- Banana
	{ id = 16131, chance = 7850 }, -- Blazing Bone
	{ id = 9636, chance = 8980 }, -- Fiery Heart
	{ id = 16130, chance = 12080 }, -- Magma Clump
	{ id = 236, chance = 7390 }, -- Strong Health Potion
	{ id = 237, chance = 7260 }, -- Strong Mana Potion
	{ id = 16123, chance = 4980 }, -- Brown Crystal Splinter
	{ id = 16126, chance = 2270 }, -- Red Crystal Fragment
	{ id = 3091, chance = 3030 }, -- Sword Ring
	{ id = 3071, chance = 990 }, -- Wand of Inferno
	{ id = 12600, chance = 840 }, -- Coal
	{ id = 817, chance = 890 }, -- Magma Amulet
	{ id = 3280, chance = 300 }, -- Fire Sword
	{ id = 826, chance = 160 }, -- Magma Coat
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -235 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -195, maxDamage = -340, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -200, range = 7, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "vulcongra soulfire", interval = 3000, chance = 100, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 50,
	mitigation = 1.46,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

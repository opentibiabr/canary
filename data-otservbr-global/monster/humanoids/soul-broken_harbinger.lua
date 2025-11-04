local mType = Game.createMonsterType("Soul-Broken Harbinger")
local monster = {}

monster.description = "a soul-broken harbinger"
monster.experience = 5800
monster.outfit = {
	lookType = 1137,
	lookHead = 85,
	lookBody = 10,
	lookLegs = 16,
	lookFeet = 83,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1734
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Court of Winter.",
}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 30137
monster.speed = 210
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 12 }, -- Platinum Coin
	{ id = 30058, chance = 15523, maxCount = 3 }, -- Ice Flower (Item)
	{ id = 30005, chance = 12998 }, -- Dream Essence Egg
	{ id = 9635, chance = 9530 }, -- Elvish Talisman
	{ id = 819, chance = 3180, maxCount = 2 }, -- Glacier Shoes
	{ id = 823, chance = 3300 }, -- Glacier Kilt
	{ id = 3284, chance = 4720 }, -- Ice Rapier
	{ id = 3371, chance = 2360 }, -- Knight Legs
	{ id = 3419, chance = 1435 }, -- Crown Shield
	{ id = 3428, chance = 1820 }, -- Tower Shield
	{ id = 3575, chance = 1370 }, -- Wood Cape
	{ id = 8074, chance = 1260 }, -- Spellbook of Mind Control
	{ id = 23529, chance = 2630 }, -- Ring of Blue Plasma
	{ id = 23543, chance = 1010 }, -- Collar of Green Plasma
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2100, chance = 40, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, range = 5, radius = 1, effect = CONST_ME_ICEAREA, target = true },
	{ name = "combat", interval = 2600, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -300, length = 4, spread = 0, effect = CONST_ME_GIANTICE, target = false },
	{ name = "combat", interval = 3100, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -300, radius = 3, effect = CONST_ME_ICEAREA, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 76,
	mitigation = 2.08,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 55 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

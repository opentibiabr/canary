local mType = Game.createMonsterType("Wyrm")
local monster = {}

monster.description = "a wyrm"
monster.experience = 1550
monster.outfit = {
	lookType = 291,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 461
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Drefia Wyrm Lair (after the Medusa Shield Quest room), Darashia Wyrm Hills, Arena and Zoo Quarter,  \z
	beneath Fenrock, Deeper Razachai, Lower Spike, Vandura Wyrm Cave and Vandura Mountain in Liberty Bay.",
}

monster.health = 1825
monster.maxHealth = 1825
monster.race = "blood"
monster.corpse = 8113
monster.speed = 140
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1,
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
	{ text = "GRROARR", yell = true },
	{ text = "GRRR", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 96890, maxCount = 230 }, -- Gold Coin
	{ id = 3583, chance = 34624, maxCount = 3 }, -- Dragon Ham
	{ id = 236, chance = 18216 }, -- Strong Health Potion
	{ id = 237, chance = 16033 }, -- Strong Mana Potion
	{ id = 9665, chance = 14491 }, -- Wyrm Scale
	{ id = 3449, chance = 38257, maxCount = 10 }, -- Burst Arrow
	{ id = 3349, chance = 6089 }, -- Crossbow
	{ id = 8043, chance = 904 }, -- Focus Cape
	{ id = 8093, chance = 688 }, -- Wand of Draconia
	{ id = 3028, chance = 1610, maxCount = 3 }, -- Small Diamond
	{ id = 816, chance = 1095 }, -- Lightning Pendant
	{ id = 8092, chance = 495 }, -- Wand of Starstorm
	{ id = 8045, chance = 282 }, -- Hibiscus Dress
	{ id = 7430, chance = 104 }, -- Dragonbone Staff
	{ id = 9304, chance = 35 }, -- Shockwave Amulet
	{ id = 8027, chance = 90 }, -- Composite Hornbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -235 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -220, radius = 3, effect = CONST_ME_YELLOWENERGY, target = false },
	{ name = "wyrm wave", interval = 2000, chance = 40, minDamage = -130, maxDamage = -200, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -125, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -98, maxDamage = -145, length = 4, spread = 3, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 34,
	mitigation = 0.83,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "effect", interval = 2000, chance = 10, radius = 1, effect = CONST_ME_SOUND_YELLOW, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 75 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

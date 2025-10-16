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
	{ id = 3031, chance = 80000, maxCount = 230 }, -- gold coin
	{ id = 3583, chance = 80000, maxCount = 3 }, -- dragon ham
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 237, chance = 23000 }, -- strong mana potion
	{ id = 9665, chance = 23000 }, -- wyrm scale
	{ id = 22119, chance = 23000, maxCount = 10 }, -- burst arrow
	{ id = 3349, chance = 23000 }, -- crossbow
	{ id = 8043, chance = 5000 }, -- focus cape
	{ id = 8093, chance = 1000 }, -- wand of draconia
	{ id = 3028, chance = 1000, maxCount = 3 }, -- small diamond
	{ id = 816, chance = 1000 }, -- lightning pendant
	{ id = 8092, chance = 260 }, -- wand of starstorm
	{ id = 8045, chance = 260 }, -- hibiscus dress
	{ id = 7430, chance = 260 }, -- dragonbone staff
	{ id = 9304, chance = 260 }, -- shockwave amulet
	{ id = 8027, chance = 260 }, -- composite hornbow
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

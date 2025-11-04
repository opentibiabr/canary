local mType = Game.createMonsterType("Wardragon")
local monster = {}

monster.description = "a wardragon"
monster.experience = 5810
monster.outfit = {
	lookType = 1708,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2458
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 5,
	Occurrence = 0,
	Locations = "Nimmersatt's Breeding Ground",
}

monster.health = 6960
monster.maxHealth = 6960
monster.race = "blood"
monster.corpse = 44656
monster.speed = 165
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
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Just Look at me!", yell = false },
	{ text = "I'll stare you down", yell = false },
	{ text = "Let me have a look", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 53806, maxCount = 30 }, -- Platinum Coin
	{ id = 9058, chance = 6231 }, -- Gold Ingot
	{ id = 24938, chance = 7874 }, -- Dragon Tongue
	{ id = 44743, chance = 11902 }, -- Nimmersatt's Seal
	{ id = 44748, chance = 12289 }, -- Wardragon Claw
	{ id = 44749, chance = 5953 }, -- Wardragon Tooth
	{ id = 3027, chance = 5029 }, -- Black Pearl
	{ id = 7643, chance = 5167 }, -- Ultimate Health Potion
	{ id = 22193, chance = 4250, maxCount = 2 }, -- Onyx Chip
	{ id = 23373, chance = 1868 }, -- Ultimate Mana Potion
	{ id = 32769, chance = 808 }, -- White Gem
	{ id = 7430, chance = 914 }, -- Dragonbone Staff
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2500, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -400, radius = 4, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -400, length = 8, spread = 4, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -275, maxDamage = -400, radius = 4, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -300, range = 2, effect = CONST_ME_BIG_SCRATCH, target = true },
}

monster.defenses = {
	defense = 80,
	armor = 80,
	mitigation = 2.19,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

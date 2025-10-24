local mType = Game.createMonsterType("Vampire")
local monster = {}

monster.description = "a vampire"
monster.experience = 305
monster.outfit = {
	lookType = 68,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 68
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Drefia, Ghost Ship between Venore and Darashia, some Ankrahmun Tombs, Lich Hell, \z
		Serpentine Tower (unreachable), Ghostlands (unreachable). House between Plains of Havoc and Dark Cathedral, \z
		Hellgate (only during Zevelon Duskbringer raid), Edron Undead Cave, Vengoth Castle (and mountains before door), \z
		Edron Vampire Crypt.",
}

monster.health = 475
monster.maxHealth = 475
monster.race = "blood"
monster.corpse = 6006
monster.speed = 119
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 30,
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
	{ text = "BLOOD!", yell = true },
	{ text = "Let me kiss your neck", yell = false },
	{ text = "I smell warm blood!", yell = false },
	{ text = "I call you, my bats! Come!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 68048, maxCount = 60 }, -- Gold Coin
	{ id = 9685, chance = 5332 }, -- Vampire Teeth
	{ id = 11449, chance = 3759 }, -- Blood Preservation
	{ id = 3661, chance = 14426 }, -- Grave Flower
	{ id = 3027, chance = 1592 }, -- Black Pearl
	{ id = 236, chance = 613 }, -- Strong Health Potion
	{ id = 3300, chance = 11334 }, -- Katana
	{ id = 3114, chance = 8041 }, -- Skull (Item)
	{ id = 3271, chance = 957 }, -- Spike Sword
	{ id = 3284, chance = 371 }, -- Ice Rapier
	{ id = 3373, chance = 299 }, -- Strange Helmet
	{ id = 3434, chance = 120 }, -- Vampire Shield
	{ id = 3010, chance = 136 }, -- Emerald Bangle
	{ id = 3056, chance = 146 }, -- Bronze Amulet
	{ id = 3081, chance = 80 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -200, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -400, range = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 60000 },
}

monster.defenses = {
	defense = 30,
	armor = 28,
	mitigation = 1.04,
	{ name = "outfit", interval = 4000, chance = 10, effect = CONST_ME_GROUNDSHAKER, target = false, duration = 5000, outfitMonster = "bat" },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 300, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 15, maxDamage = 25, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

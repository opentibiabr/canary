local mType = Game.createMonsterType("Zombie")
local monster = {}

monster.description = "a zombie"
monster.experience = 280
monster.outfit = {
	lookType = 311,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 512
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Cemetery Quarter, Drefia, Vampire Castle, Treasure Island, Isle of Evil, Upper Spike.",
}

monster.health = 500
monster.maxHealth = 500
monster.race = "undead"
monster.corpse = 8961
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	{ text = "Mst.... klll....", yell = false },
	{ text = "Whrrrr... ssss.... mmm.... grrrrl", yell = false },
	{ text = "Dnnnt... cmmm... clsrrr....", yell = false },
	{ text = "Httt.... hmnnsss...", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 81903, maxCount = 65 }, -- Gold Coin
	{ id = 3286, chance = 8203 }, -- Mace
	{ id = 3305, chance = 6800 }, -- Battle Hammer
	{ id = 3354, chance = 10003 }, -- Brass Helmet
	{ id = 9659, chance = 10656 }, -- Half-Eaten Brain
	{ id = 8894, chance = 5427 }, -- Heavily Rusted Armor
	{ id = 3269, chance = 3969 }, -- Halberd
	{ id = 3351, chance = 4809 }, -- Steel Helmet
	{ id = 268, chance = 789 }, -- Mana Potion
	{ id = 3052, chance = 1261 }, -- Life Ring
	{ id = 3568, chance = 460 }, -- Simple Dress
	{ id = 3081, chance = 700 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -14, maxDamage = -23, range = 1, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -15, maxDamage = -24, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -49, range = 1, effect = CONST_ME_SMALLCLOUDS, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 20,
	mitigation = 0.83,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

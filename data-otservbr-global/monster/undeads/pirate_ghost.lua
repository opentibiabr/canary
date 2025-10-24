local mType = Game.createMonsterType("Pirate Ghost")
local monster = {}

monster.description = "a pirate ghost"
monster.experience = 250
monster.outfit = {
	lookType = 196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 257
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Drefia, Goroma, Nargor Undead Cave, hidden caves under Treasure Island, \z
		single spawn at Liberty Bay ruins, Chyllfroest (unreachable).",
}

monster.health = 275
monster.maxHealth = 275
monster.race = "undead"
monster.corpse = 5565
monster.speed = 105
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
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
	{ text = "Yooh Ho Hooh Ho!", yell = false },
	{ text = "Hell is waiting for You!", yell = false },
	{ text = "It's alive!", yell = false },
	{ text = "The curse! Aww the curse!", yell = false },
	{ text = "You will not get my treasure.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 48292, maxCount = 67 }, -- Gold Coin
	{ id = 9684, chance = 5144 }, -- Tattered Piece of Robe
	{ id = 2814, chance = 1080 }, -- Parchment (Rewritable)
	{ id = 3049, chance = 690 }, -- Stealth Ring
	{ id = 3566, chance = 50 }, -- Red Robe
	{ id = 3271, chance = 471 }, -- Spike Sword
	{ id = 3081, chance = 2110 }, -- Stone Skin Amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -100, condition = { type = CONDITION_POISON, totalDamage = 40, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -40, maxDamage = -80, radius = 1, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -50, maxDamage = -65, range = 7, radius = 3, effect = CONST_ME_SOUND_RED, target = true },
}

monster.defenses = {
	defense = 0,
	armor = 30,
	mitigation = 0.78,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 40, maxDamage = 70, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

local mType = Game.createMonsterType("Gladiator")
local monster = {}

monster.description = "a gladiator"
monster.experience = 90
monster.outfit = {
	lookType = 131,
	lookHead = 78,
	lookBody = 3,
	lookLegs = 79,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 527
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Trade Quarter, Arena and Zoo Quarter.",
}

monster.health = 185
monster.maxHealth = 185
monster.race = "blood"
monster.corpse = 18126
monster.speed = 98
monster.manaCost = 470

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You are no match for me!", yell = false },
	{ text = "Feel my prowess.", yell = false },
	{ text = "Fight!", yell = false },
	{ text = "Take this!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 30 }, -- gold coin
	{ id = 3286, chance = 23000 }, -- mace
	{ id = 3577, chance = 23000 }, -- meat
	{ id = 3410, chance = 23000 }, -- plate shield
	{ id = 3264, chance = 23000 }, -- sword
	{ id = 3352, chance = 5000 }, -- chain helmet
	{ id = 3359, chance = 5000 }, -- brass armor
	{ id = 3353, chance = 1000 }, -- iron helmet
	{ id = 3409, chance = 1000 }, -- steel shield
	{ id = 8044, chance = 1000 }, -- belted cape
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90 },
}

monster.defenses = {
	defense = 25,
	armor = 14,
	mitigation = 0.78,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 215, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

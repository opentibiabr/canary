local mType = Game.createMonsterType("Undead Mine Worker")
local monster = {}

monster.description = "an undead mine worker"
monster.experience = 45
monster.outfit = {
	lookType = 33,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 594
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 1,
	Locations = "West of Edron in the Lost Mines.",
}

monster.health = 65
monster.maxHealth = 65
monster.race = "undead"
monster.corpse = 5972
monster.speed = 77
monster.manaCost = 435

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = true,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = true,
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
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ahrrr... uhmmm... hmm...", yell = false },
	{ text = "Grrr...", yell = false },
	{ text = "Urrrgh... gnarrr...", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 73000, maxCount = 10 },
	{ id = 3115, chance = 42000 }, -- bone
	{ id = 3264, chance = 3850 }, -- sword
	{ name = "mace", chance = 26900 },
	{ name = "white mushroom", chance = 15400, maxCount = 3 },
	{ name = "brown mushroom", chance = 3850 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -30 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -7, maxDamage = -13, range = 1, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 5,
	mitigation = 0.25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
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

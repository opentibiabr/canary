local mType = Game.createMonsterType("Ice Golem")
local monster = {}

monster.description = "an ice golem"
monster.experience = 295
monster.outfit = {
	lookType = 261,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 326
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Formorgar Glacier, Formorgar Mines, Nibelor Ice Cave, Ice Witch Temple, \z
		Deeper Banuta, Crystal Caves, Chyllfroest.",
}

monster.health = 385
monster.maxHealth = 385
monster.race = "undead"
monster.corpse = 7282
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	canPushCreatures = false,
	staticAttackChance = 50,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Chrrr.", yell = false },
	{ text = "Crrrrk.", yell = false },
	{ text = "Gnarr.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 111 }, -- gold coin
	{ id = 9661, chance = 23000 }, -- frosty heart
	{ id = 7741, chance = 5000 }, -- ice cube
	{ id = 237, chance = 5000 }, -- strong mana potion
	{ id = 236, chance = 5000 }, -- strong health potion
	{ id = 3027, chance = 5000 }, -- black pearl
	{ id = 3028, chance = 1000 }, -- small diamond
	{ id = 7449, chance = 1000 }, -- crystal sword
	{ id = 3029, chance = 1000 }, -- small sapphire
	{ id = 3373, chance = 260 }, -- strange helmet
	{ id = 3284, chance = 260 }, -- ice rapier
	{ id = 7290, chance = 260 }, -- shard
	{ id = 829, chance = 260 }, -- glacier mask
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -220 },
	{ name = "speed", interval = 1000, chance = 13, speedChange = -800, length = 8, spread = 0, effect = CONST_ME_ENERGYHIT, target = false, duration = 20000 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -50, maxDamage = -85, range = 7, shootEffect = CONST_ANI_SMALLICE, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "ice golem skill reducer", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 26,
	armor = 47,
	mitigation = 0.70,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

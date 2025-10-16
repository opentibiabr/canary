local mType = Game.createMonsterType("Quara Hydromancer Scout")
local monster = {}

monster.description = "a quara hydromancer scout"
monster.experience = 800
monster.outfit = {
	lookType = 47,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 244
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Malada, Hrodmir Quara Scout Caves, Quara Grotto, Oramond.",
}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "undead"
monster.corpse = 6066
monster.speed = 95
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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Qua hah tsh!", yell = false },
	{ text = "Teech tsha tshul!", yell = false },
	{ text = "Quara tsha Fach!", yell = false },
	{ text = "Tssssha Quara!", yell = false },
	{ text = "Blubber.", yell = false },
	{ text = "Blup.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 139 }, -- gold coin
	{ id = 7885, chance = 23000, maxCount = 3 }, -- fish
	{ id = 3581, chance = 23000, maxCount = 4 }, -- shrimp
	{ id = 11488, chance = 23000 }, -- quara eye
	{ id = 3026, chance = 5000 }, -- white pearl
	{ id = 3027, chance = 5000 }, -- black pearl
	{ id = 3032, chance = 5000, maxCount = 2 }, -- small emerald
	{ id = 3313, chance = 5000 }, -- obsidian lance
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 3073, chance = 1000 }, -- wand of cosmic energy
	{ id = 3098, chance = 1000 }, -- ring of healing
	{ id = 3370, chance = 1000 }, -- knight armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -80, effect = CONST_ME_DRAWBLOOD, condition = { type = CONDITION_POISON, totalDamage = 100, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -180, length = 8, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -90, maxDamage = -150, radius = 3, effect = CONST_ME_BUBBLES, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -170, maxDamage = -240, length = 8, spread = 0, effect = CONST_ME_BUBBLES, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -170, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 15,
	armor = 30,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

local mType = Game.createMonsterType("Renegade Quara Hydromancer")
local monster = {}

monster.description = "a renegade quara hydromancer"
monster.experience = 1800
monster.outfit = {
	lookType = 47,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1098
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6066
monster.speed = 245
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 4 }, -- platinum coin
	{ id = 11488, chance = 23000 }, -- quara eye
	{ id = 3062, chance = 23000 }, -- mind stone
	{ id = 3581, chance = 23000 }, -- shrimp
	{ id = 9057, chance = 23000, maxCount = 2 }, -- small topaz
	{ id = 3032, chance = 23000, maxCount = 2 }, -- small emerald
	{ id = 238, chance = 23000, maxCount = 2 }, -- great mana potion
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 8042, chance = 5000 }, -- spirit cloak
	{ id = 5914, chance = 5000 }, -- yellow piece of cloth
	{ id = 5910, chance = 5000 }, -- green piece of cloth
	{ id = 16121, chance = 5000 }, -- green crystal shard
	{ id = 3052, chance = 5000 }, -- life ring
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 3073, chance = 1000 }, -- wand of cosmic energy
	{ id = 3370, chance = 1000 }, -- knight armor
	{ id = 3038, chance = 260 }, -- green gem
	{ id = 3027, chance = 80000 }, -- black pearl
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 3026, chance = 80000 }, -- white pearl
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 110, attack = 90, effect = CONST_ME_DRAWBLOOD, condition = { type = CONDITION_POISON, totalDamage = 5, interval = 4000 } },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -350, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
}

monster.defenses = {
	defense = 15,
	armor = 30,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
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

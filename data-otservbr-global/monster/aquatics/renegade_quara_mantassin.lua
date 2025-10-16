local mType = Game.createMonsterType("Renegade Quara Mantassin")
local monster = {}

monster.description = "a renegade quara mantassin"
monster.experience = 1000
monster.outfit = {
	lookType = 72,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1099
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

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 6064
monster.speed = 295
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
	{ id = 11489, chance = 23000 }, -- mantassin tail
	{ id = 3062, chance = 23000 }, -- mind stone
	{ id = 3049, chance = 5000 }, -- stealth ring
	{ id = 3581, chance = 5000, maxCount = 4 }, -- shrimp
	{ id = 3029, chance = 5000, maxCount = 2 }, -- small sapphire
	{ id = 16119, chance = 5000 }, -- blue crystal shard
	{ id = 3284, chance = 5000 }, -- ice rapier
	{ id = 3373, chance = 5000 }, -- strange helmet
	{ id = 5895, chance = 1000 }, -- fish fin
	{ id = 3265, chance = 1000 }, -- two handed sword
	{ id = 3567, chance = 1000 }, -- blue robe
	{ id = 3051, chance = 1000 }, -- energy ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 40, attack = 55, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 15,
	armor = 16,
	mitigation = 0.70,
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
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
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)

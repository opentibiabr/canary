local mType = Game.createMonsterType("Renegade Quara Predator")
local monster = {}

monster.description = "a renegade quara predator"
monster.experience = 2700
monster.outfit = {
	lookType = 20,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1101
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

monster.health = 3250
monster.maxHealth = 3250
monster.race = "blood"
monster.corpse = 6067
monster.speed = 225
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
	illusionable = true,
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
	{ id = 11491, chance = 23000 }, -- quara bone
	{ id = 7378, chance = 23000, maxCount = 7 }, -- royal spear
	{ id = 3062, chance = 23000 }, -- mind stone
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 7368, chance = 5000, maxCount = 10 }, -- assassin star
	{ id = 3581, chance = 5000, maxCount = 3 }, -- shrimp
	{ id = 3028, chance = 5000, maxCount = 3 }, -- small diamond
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 16119, chance = 1000 }, -- blue crystal shard
	{ id = 7383, chance = 1000 }, -- relic sword
	{ id = 824, chance = 1000 }, -- glacier robe
	{ id = 7414, chance = 260 }, -- abyss hammer
	{ id = 8059, chance = 260 }, -- frozen plate
	{ id = 5741, chance = 260 }, -- skull helmet
	{ id = 12318, chance = 260 }, -- giant shrimp
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 100, attack = 82, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	mitigation = 1.46,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 30, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
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

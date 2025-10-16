local mType = Game.createMonsterType("Ogre Brute")
local monster = {}

monster.description = "an ogre brute"
monster.experience = 800
monster.outfit = {
	lookType = 857,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1161
monster.Bestiary = {
	class = "Giant",
	race = BESTY_RACE_GIANT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Krailos Steppe.",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "blood"
monster.corpse = 22143
monster.speed = 102
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
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
	{ text = "You so juicy!", yell = false },
	{ text = "Smash you face in!!!", yell = false },
	{ text = "You stop! You lunch!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 125 }, -- gold coin
	{ id = 3577, chance = 23000, maxCount = 2 }, -- meat
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 22189, chance = 23000 }, -- ogre nose ring
	{ id = 22188, chance = 23000 }, -- ogre ear stud
	{ id = 3598, chance = 5000, maxCount = 5 }, -- cookie
	{ id = 1781, chance = 5000, maxCount = 5 }, -- small stone
	{ id = 11447, chance = 5000 }, -- battle stone
	{ id = 22191, chance = 5000 }, -- skull fetish
	{ id = 3050, chance = 5000 }, -- power ring
	{ id = 3093, chance = 5000 }, -- club ring
	{ id = 22193, chance = 5000, maxCount = 2 }, -- onyx chip
	{ id = 3030, chance = 5000 }, -- small ruby
	{ id = 3026, chance = 5000 }, -- white pearl
	{ id = 22194, chance = 5000, maxCount = 2 }, -- opal
	{ id = 22171, chance = 1000 }, -- ogre klubba
	{ id = 8907, chance = 260 }, -- rusted helmet
	{ id = 9632, chance = 260 }, -- ancient stone
	{ id = 3465, chance = 260 }, -- pot
	{ id = 7428, chance = 260 }, -- bonebreaker
	{ id = 22192, chance = 260 }, -- shamanic mask
	{ id = 7412, chance = 260 }, -- butchers axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -269, condition = { type = CONDITION_FIRE, totalDamage = 6, interval = 9000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -70, maxDamage = -180, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_TELEPORT, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 41,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

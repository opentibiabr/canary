local mType = Game.createMonsterType("Afflicted Strider")
local monster = {}

monster.description = "an afflicted strider"
monster.experience = 5700
monster.outfit = {
	lookType = 1403,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2094
monster.Bestiary = {
	class = "Vermin",
	race = BESTY_RACE_VERMIN,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Antrum of the Fallen.",
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 36719
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 70,
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
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 15 }, -- platinum coin
	{ id = 3036, chance = 23000 }, -- violet gem
	{ id = 3315, chance = 23000 }, -- guardian halberd
	{ id = 7449, chance = 23000 }, -- crystal sword
	{ id = 16120, chance = 23000 }, -- violet crystal shard
	{ id = 16121, chance = 23000 }, -- green crystal shard
	{ id = 36790, chance = 23000 }, -- afflicted strider worms
	{ id = 826, chance = 5000 }, -- magma coat
	{ id = 3284, chance = 5000 }, -- ice rapier
	{ id = 3297, chance = 5000 }, -- serpent sword
	{ id = 3301, chance = 5000 }, -- broadsword
	{ id = 3308, chance = 5000 }, -- machete
	{ id = 3318, chance = 5000 }, -- knight axe
	{ id = 3370, chance = 5000 }, -- knight armor
	{ id = 3379, chance = 5000 }, -- doublet
	{ id = 7386, chance = 5000 }, -- mercenary sword
	{ id = 7407, chance = 5000 }, -- haunted blade
	{ id = 7413, chance = 5000 }, -- titan axe
	{ id = 8042, chance = 5000 }, -- spirit cloak
	{ id = 8043, chance = 5000 }, -- focus cape
	{ id = 8044, chance = 5000 }, -- belted cape
	{ id = 36789, chance = 5000 }, -- afflicted strider head
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -550, maxDamage = -650, range = 3, shootEffect = CONST_ANI_POISON, target = true },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_DEATHDAMAGE, minDamage = -650, maxDamage = -800, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = false },
}

monster.defenses = {
	defense = 68,
	armor = 68,
	mitigation = 1.88,
	{ name = "speed", interval = 2000, chance = 25, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
